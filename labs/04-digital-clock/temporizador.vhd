----------------------------------------------------------------------------------
-- LAB 4 - Projeto 1 - Componente TEMPORIZADOR
--
-- Conta horas, minutos e segundos a partir do clock da placa e entrega quatro
-- digitos BCD para o driver dos displays.
--
--   rst   = '1' -> zera a contagem (assincrono, precedencia sobre tudo)
--   pausa = '1' -> congela a contagem, sem zerar
--   conf  = '1' -> saidas representam HORAS e MINUTOS
--   conf  = '0' -> saidas representam MINUTOS e SEGUNDOS
--
-- DIV_SEG e o numero de ciclos de clk que formam um segundo (50e6 para 50 MHz).
-- Na simulacao usa-se um valor pequeno para encurtar o tempo.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity temporizador is
    generic ( DIV_SEG : integer := 50000000 );
    Port ( clk   : in  STD_LOGIC;
           rst   : in  STD_LOGIC;
           pausa : in  STD_LOGIC;
           conf  : in  STD_LOGIC;
           dmin  : out STD_LOGIC_VECTOR (3 downto 0);   -- digito mais a esquerda
           umin  : out STD_LOGIC_VECTOR (3 downto 0);
           dseg  : out STD_LOGIC_VECTOR (3 downto 0);
           useg  : out STD_LOGIC_VECTOR (3 downto 0));  -- digito mais a direita
end temporizador;

architecture Behavioral of temporizador is

   signal presc : integer range 0 to DIV_SEG-1 := 0;   -- divisor ate um segundo

   signal us : integer range 0 to 9 := 0;   -- unidade de segundos
   signal ds : integer range 0 to 5 := 0;   -- dezena  de segundos
   signal um : integer range 0 to 9 := 0;   -- unidade de minutos
   signal dm : integer range 0 to 5 := 0;   -- dezena  de minutos
   signal uh : integer range 0 to 9 := 0;   -- unidade de horas
   signal dh : integer range 0 to 2 := 0;   -- dezena  de horas

begin

   contagem: process(clk, rst)
   begin
      if rst = '1' then                     -- assincrono: tem precedencia sobre
         presc <= 0;                        -- o clock, a pausa e o conf
         us <= 0;  ds <= 0;
         um <= 0;  dm <= 0;
         uh <= 0;  dh <= 0;

      elsif clk'event and clk = '1' then

         if pausa = '0' then                -- com pausa = '1' nada e atualizado

            if presc = DIV_SEG-1 then
               presc <= 0;

               -- cascata: segundos -> minutos -> horas
               if us = 9 then
                  us <= 0;

                  if ds = 5 then
                     ds <= 0;

                     if um = 9 then
                        um <= 0;

                        if dm = 5 then
                           dm <= 0;

                           if dh = 2 and uh = 3 then   -- 23:59:59 -> 00:00:00
                              uh <= 0;
                              dh <= 0;
                           elsif uh = 9 then
                              uh <= 0;
                              dh <= dh + 1;
                           else
                              uh <= uh + 1;
                           end if;

                        else
                           dm <= dm + 1;
                        end if;

                     else
                        um <= um + 1;
                     end if;

                  else
                     ds <= ds + 1;
                  end if;

               else
                  us <= us + 1;
               end if;

            else
               presc <= presc + 1;
            end if;

         end if;
      end if;
   end process;

   -- selecao do par exibido, conforme a entrada conf
   dmin <= std_logic_vector(to_unsigned(dh, 4)) when conf = '1'
           else std_logic_vector(to_unsigned(dm, 4));

   umin <= std_logic_vector(to_unsigned(uh, 4)) when conf = '1'
           else std_logic_vector(to_unsigned(um, 4));

   dseg <= std_logic_vector(to_unsigned(dm, 4)) when conf = '1'
           else std_logic_vector(to_unsigned(ds, 4));

   useg <= std_logic_vector(to_unsigned(um, 4)) when conf = '1'
           else std_logic_vector(to_unsigned(us, 4));

end Behavioral;
