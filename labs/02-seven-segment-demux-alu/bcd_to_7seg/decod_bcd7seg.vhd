library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decod_bcd7seg is
    Port ( d   : in  STD_LOGIC_VECTOR (3 downto 0);   -- D3 D2 D1 D0 (BCD)
           seg : out STD_LOGIC_VECTOR (6 downto 0);   -- /a /b /c /d /e /f /g
           an  : out STD_LOGIC_VECTOR (3 downto 0));  -- anodos do display (ativo baixo)
end decod_bcd7seg;

architecture Behavioral of decod_bcd7seg is
begin

   -- habilita apenas o display 0; os outros tres ficam apagados
   an <= "1110";

   --                    a b c d e f g
   with d select seg <=
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
      "1111111" when others;   --  display apagado

end Behavioral;
