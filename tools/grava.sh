#!/usr/bin/env bash
# grava.sh - compila (se preciso) e grava um projeto ISE na Nexys 2 conectada
#
#   ./grava.sh                  lista os projetos
#   ./grava.sh bcd              grava o projeto cujo nome contem "bcd"
#   ./grava.sh ula -r           forca recompilar antes de gravar
#
# Detecta sozinho se a placa e a Nexys 2 de 500 ou de 1200 mil portas e ajusta
# o device e os pinos dos LEDs 4-7 do projeto antes de compilar.

set -uo pipefail

RAIZ=${XILINX_PROJECTS:-/home/degolas/xilinx-projects}
CONTAINER=xilinx-ise
SETTINGS=/opt/Xilinx/14.7/ISE_DS/settings64.sh
PADRAO=xc3s1200e            # a placa do dono; usada so na listagem

v()  { printf '\033[1;32m%s\033[0m\n' "$*"; }
i()  { printf '\033[0;36m%s\033[0m\n' "$*"; }
a()  { printf '\033[1;33m%s\033[0m\n' "$*"; }
err(){ printf '\033[1;31m%s\033[0m\n' "$*" >&2; }

dev_do_projeto() { grep -oE 'name="Device" xil_pn:value="[^"]*"' "$1" | cut -d'"' -f4; }

listar() {
    echo "projetos disponiveis:"
    for d in "$RAIZ"/*/; do
        x=$(ls "$d"*.xise 2>/dev/null | head -1); [ -n "$x" ] || continue
        bit=$(ls -t "$d"*.bit 2>/dev/null | head -1)
        if [ -n "$bit" ]; then est="bit de $(date -r "$bit" '+%d/%m %H:%M')"; else est="sem bit"; fi
        dv=$(dev_do_projeto "$x")
        [ "$dv" = "$PADRAO" ] && marca="" || marca="  <- device $dv"
        printf '   %-26s %s%s\n' "$(basename "$d")" "$est" "$marca"
    done
}

# ajusta os LOC dos LEDs 4 a 7, que mudam entre as duas versoes da placa
ajusta_leds() {   # $1 = arquivo ucf   $2 = device alvo
    [ -f "$1" ] || return 0
    if [ "$2" = xc3s1200e ]; then
        sed -i -e 's/LOC = "E17"/LOC = "E16"/' -e 's/LOC = "P15"/LOC = "P16"/' \
               -e 's/LOC = "F4"/LOC = "E4"/'   -e 's/LOC = "R4"/LOC = "P4"/' "$1"
    else
        sed -i -e 's/LOC = "E16"/LOC = "E17"/' -e 's/LOC = "P16"/LOC = "P15"/' \
               -e 's/LOC = "E4"/LOC = "F4"/'   -e 's/LOC = "P4"/LOC = "R4"/' "$1"
    fi
}

[ $# -ge 1 ] || { listar; exit 0; }
ALVO="$1"; FORCAR="${2:-}"

PASTA=$(ls -d "$RAIZ"/*"$ALVO"*/ 2>/dev/null | head -1)
[ -n "$PASTA" ] || { err "nenhum projeto casa com '$ALVO'"; listar; exit 1; }
PASTA=${PASTA%/}; NOME=$(basename "$PASTA")
XISE=$(ls "$PASTA"/*.xise 2>/dev/null | head -1)
[ -n "$XISE" ] || { err "$NOME nao tem .xise"; exit 1; }

docker ps --format '{{.Names}}' | grep -qx "$CONTAINER" || {
    err "container '$CONTAINER' nao esta rodando"; exit 1; }
lsusb 2>/dev/null | grep -q "1443:" || {
    err "placa nao detectada no USB - ligue a Nexys 2 e conecte o cabo"; exit 1; }

i "projeto: $NOME"

# ---------- que placa esta conectada? ----------
CHAIN=$(docker exec -w /tmp "$CONTAINER" bash -lc "source $SETTINGS >/dev/null 2>&1
printf 'setMode -bs\nsetCable -port auto\nidentify\nquit\n' > _id.cmd
impact -batch _id.cmd 2>&1" )
DEV_PLACA=$(grep -oE "xc3s(500|1200)e" <<<"$CHAIN" | head -1)
[ -n "$DEV_PLACA" ] || { err "nao consegui identificar o FPGA na cadeia JTAG"
                         grep -iE "ERROR|cable" <<<"$CHAIN" | tail -3; exit 1; }

DEV_PROJ=$(dev_do_projeto "$XISE")
RETARGET=nao
if [ "$DEV_PLACA" != "$DEV_PROJ" ]; then
    RETARGET=sim
    a "placa conectada e $DEV_PLACA, projeto estava em $DEV_PROJ - ajustando"
    ajusta_leds "$PASTA/pins.ucf" "$DEV_PLACA"
    cat > "$PASTA/_rt.tcl" <<EOF
project open $(basename "$XISE")
project set device "$DEV_PLACA"
project set family "Spartan3E"
project set package "fg320"
project set speed "-4"
project save
project close
EOF
    docker exec -w "/projects/$NOME" "$CONTAINER" \
        bash -lc "source $SETTINGS >/dev/null 2>&1; xtclsh _rt.tcl" >/dev/null 2>&1
    rm -f "$PASTA/_rt.tcl" "$PASTA"/iseconfig/*.projectmgr 2>/dev/null
else
    i "placa: $DEV_PLACA"
fi

# ---------- o bitstream esta atualizado? ----------
BIT=$(ls -t "$PASTA"/*.bit 2>/dev/null | head -1)
PRECISA=nao
if [ "$RETARGET" = sim ]; then
    PRECISA=sim; MOTIVO="device mudou para $DEV_PLACA"
elif [ -z "$BIT" ]; then
    PRECISA=sim; MOTIVO="ainda nao existe bitstream"
elif [ "$FORCAR" = "-r" ]; then
    PRECISA=sim; MOTIVO="recompilacao forcada (-r)"
else
    NOVO=$(find "$PASTA" -maxdepth 1 \( -name '*.vhd' ! -name '*_simu.vhd' -o -name '*.ucf' \) -newer "$BIT" -print -quit)
    [ -n "$NOVO" ] && { PRECISA=sim; MOTIVO="$(basename "$NOVO") mudou depois do ultimo bitstream"; }
fi

if [ "$PRECISA" = sim ]; then
    i "compilando: $MOTIVO"
    cat > "$PASTA/_grava.tcl" <<EOF
project open $(basename "$XISE")
process run "Generate Programming File"
project close
EOF
    saida=$(timeout 900 docker exec -w "/projects/$NOME" "$CONTAINER" \
        bash -lc "source $SETTINGS >/dev/null 2>&1; xtclsh _grava.tcl" 2>&1)
    rm -f "$PASTA/_grava.tcl" "$PASTA"/iseconfig/*.projectmgr 2>/dev/null
    if ! grep -q 'Generate Programming File" completed successfully' <<<"$saida"; then
        err "a compilacao falhou:"; grep -E "^ERROR" <<<"$saida" | sort -u | head -5; exit 1
    fi
    BIT=$(ls -t "$PASTA"/*.bit | head -1)
    v "bitstream gerado: $(basename "$BIT")"
else
    i "bitstream atual: $(basename "$BIT")"
fi

# ---------- grava ----------
i "gravando na placa..."
docker exec -w /tmp "$CONTAINER" bash -lc "source $SETTINGS >/dev/null 2>&1
cat > _g.cmd <<EOF
setMode -bs
setCable -port auto
identify
assignFile -p 1 -file \"/projects/$NOME/$(basename "$BIT")\"
program -p 1
quit
EOF
impact -batch _g.cmd >/dev/null 2>&1
cat /tmp/_impactbatch.log" > /tmp/_grava_log.txt 2>&1

if grep -q "Programmed successfully" /tmp/_grava_log.txt; then
    v "OK - $NOME esta rodando na placa"
    [ "$RETARGET" = sim ] && [ "$DEV_PLACA" != "$PADRAO" ] && \
      a "atencao: o projeto ficou salvo para $DEV_PLACA. Antes de entregar, rode de novo com a sua placa $PADRAO conectada."
else
    err "a gravacao falhou:"; grep -iE "ERROR|idcode|cable" /tmp/_grava_log.txt | tail -5; exit 1
fi
