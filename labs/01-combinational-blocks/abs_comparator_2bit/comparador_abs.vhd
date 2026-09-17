----------------------------------------------------------------------------------
-- Module Name:    comparador_abs - Behavioral
-- Description:    Comparador de valor absoluto de dois numeros de 2 bits em
--                 complemento de 2 (00=0, 01=+1, 10=-2, 11=-1).
--                 s = '1' sempre que a = b ou a = -b, isto e, |a| = |b|.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity comparador_abs is
    Port ( a1 : in  STD_LOGIC;
           a0 : in  STD_LOGIC;
           b1 : in  STD_LOGIC;
           b0 : in  STD_LOGIC;
           s  : out STD_LOGIC);
end comparador_abs;

architecture Behavioral of comparador_abs is

begin

   s <= (a0 and b0)                                      -- |a| = |b| = 1
        or (not a1 and not a0 and not b1 and not b0)     -- |a| = |b| = 0
        or (a1 and not a0 and b1 and not b0);            -- |a| = |b| = 2

end Behavioral;
