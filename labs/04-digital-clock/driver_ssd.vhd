----------------------------------------------------------------------------------
-- LAB 4 - Projeto 1 - Componente DRIVER SSD
--
-- Os quatro displays da Nexys 2 compartilham os mesmos sinais de catodo, por isso
-- precisam ser multiplexados: um digito e aceso de cada vez, em rodizio rapido o
-- bastante para a vista perceber os quatro acesos ao mesmo tempo.
--
-- Segmentos e anodos sao ativos em nivel BAIXO (display de anodo comum).
--
-- DIV_REF e o numero de ciclos de clk que cada digito fica aceso.
-- Com 50 MHz, 50000 ciclos = 1 ms por digito (varredura de 250 Hz).
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity driver_ssd is
    generic ( DIV_REF : integer := 50000 );
    Port ( clk  : in  STD_LOGIC;
           rst  : in  STD_LOGIC;
           dmin : in  STD_LOGIC_VECTOR (3 downto 0);   -- digito mais a esquerda
           umin : in  STD_LOGIC_VECTOR (3 downto 0);
           dseg : in  STD_LOGIC_VECTOR (3 downto 0);
           useg : in  STD_LOGIC_VECTOR (3 downto 0);   -- digito mais a direita
           dig  : out STD_LOGIC_VECTOR (6 downto 0);   -- segmentos a..g (ativo baixo)
           an   : out STD_LOGIC_VECTOR (3 downto 0));  -- anodos AN3..AN0 (ativo baixo)
end driver_ssd;

architecture Behavioral of driver_ssd is

   signal presc : integer range 0 to DIV_REF-1 := 0;
   signal sel   : integer range 0 to 3 := 0;        -- digito da vez
   signal bcd   : STD_LOGIC_VECTOR (3 downto 0);    -- valor enviado ao decodificador

begin

   varredura: process(clk, rst)
   begin
      if rst = '1' then
         presc <= 0;
         sel   <= 0;

      elsif clk'event and clk = '1' then

         if presc = DIV_REF-1 then
            presc <= 0;
            if sel = 3 then
               sel <= 0;
            else
               sel <= sel + 1;
            end if;
         else
            presc <= presc + 1;
         end if;

      end if;
   end process;

   -- multiplexacao dos quatro digitos
   with sel select bcd <=
      useg when 0,
      dseg when 1,
      umin when 2,
      dmin when others;

   -- anodo do digito da vez em nivel baixo; os outros tres apagados
   with sel select an <=
      "1110" when 0,
      "1101" when 1,
      "1011" when 2,
      "0111" when others;

   -- decodificador BCD para 7 segmentos, saidas ativas em nivel baixo
   --                    a b c d e f g
   with bcd select dig <=
      "0000001" when "0000",   -- 0
      "1001111" when "0001",   -- 1
      "0010010" when "0010",   -- 2
      "0000110" when "0011",   -- 3
      "1001100" when "0100",   -- 4
      "0100100" when "0101",   -- 5
      "0100000" when "0110",   -- 6
      "0001111" when "0111",   -- 7
      "0000000" when "1000",   -- 8
      "0000100" when "1001",   -- 9
      "1111111" when others;   -- valor nao-BCD: digito apagado

end Behavioral;
