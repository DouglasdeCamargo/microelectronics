library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ula is
    generic ( N : integer := 2 );
    Port ( enable   : in  STD_LOGIC;
           a        : in  STD_LOGIC_VECTOR (N-1 downto 0);
           b        : in  STD_LOGIC_VECTOR (N-1 downto 0);
           opcode   : in  STD_LOGIC_VECTOR (2 downto 0);
           y        : out STD_LOGIC_VECTOR (N-1 downto 0);
           cout     : out STD_LOGIC;
           overflow : out STD_LOGIC);
end ula;

architecture Behavioral of ula is

   -- operandos com um bit a mais: a posicao N guarda o vai-um (cout).
   -- os N bits de baixo do resultado sao os mesmos do calculo com sinal,
   -- porque a soma em complemento de 2 tem o mesmo padrao de bits.
   signal ax, bx : signed(N downto 0);
   signal r      : signed(N downto 0);

   signal ov_add, ov_sub, ov_inc, ov_dec : std_logic;
   signal c, ov : std_logic;

begin

   ax <= signed('0' & a);
   bx <= signed('0' & b);

   -- ---------------- operacao ----------------
   with opcode select r <=
      ax + bx          when "000",
      ax - bx          when "001",
      ax and bx        when "010",
      ax or  bx        when "011",
      ax xor bx        when "100",
      not ax           when "101",
      ax + 1           when "110",
      ax - 1           when "111",
      (others => '0')  when others;

   y <= (others => '0') when enable = '0'
        else std_logic_vector(r(N-1 downto 0));

   -- ---------------- vai-um / vem-um ----------------
   with opcode select c <=
      r(N) when "000",    -- vai-um da soma
      r(N) when "001",    -- vem-um (borrow) da subtracao
      r(N) when "110",    -- a + 1
      r(N) when "111",    -- a - 1
      '0'  when others;   -- operacoes logicas nao geram carry

   cout <= c when enable = '1' else '0';

   -- ---------------- overflow com sinal ----------------
   -- soma: estoura quando os operandos tem o mesmo sinal e o resultado muda de sinal
   ov_add <= (a(N-1) xnor b(N-1)) and (r(N-1) xor a(N-1));
   -- subtracao: estoura quando os operandos tem sinais opostos e o resultado
   -- fica com o sinal de b
   ov_sub <= (a(N-1) xor  b(N-1)) and (r(N-1) xor a(N-1));
   -- a+1 so estoura saindo de positivo para negativo; a-1, o contrario
   ov_inc <= (not a(N-1)) and r(N-1);
   ov_dec <= a(N-1) and (not r(N-1));

   with opcode select ov <=
      ov_add when "000",
      ov_sub when "001",
      ov_inc when "110",
      ov_dec when "111",
      '0'    when others;

   overflow <= ov when enable = '1' else '0';

end Behavioral;
