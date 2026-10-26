library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity demux1x8 is
    Port ( en  : in  STD_LOGIC;
           d   : in  STD_LOGIC;
           sel : in  STD_LOGIC_VECTOR (2 downto 0);
           y   : out STD_LOGIC_VECTOR (7 downto 0));
end demux1x8;

architecture Behavioral of demux1x8 is

   signal linha : STD_LOGIC_VECTOR (7 downto 0);   -- saida escolhida por sel

begin

   -- qual das oito saidas vai receber o dado
   with sel select linha <=
      "00000001" when "000",
      "00000010" when "001",
      "00000100" when "010",
      "00001000" when "011",
      "00010000" when "100",
      "00100000" when "101",
      "01000000" when "110",
      "10000000" when others;   -- "111"

   -- o dado so passa com en = '1'; com d = '0' nenhuma saida acende
   y <= linha when (en = '1' and d = '1') else "00000000";

end Behavioral;
