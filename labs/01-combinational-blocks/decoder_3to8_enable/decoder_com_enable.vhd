----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:06:52 09/11/2026 
-- Design Name: 
-- Module Name:    decoder_com_enable - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity decoder_com_enable is
    Port ( a0 : in  STD_LOGIC;
           a1 : in  STD_LOGIC;
           a2 : in  STD_LOGIC;
           b0 : out  STD_LOGIC;
			  b1 : out	STD_LOGIC;
           b2 : out  STD_LOGIC;
           b3 : out  STD_LOGIC;
           b4 : out  STD_LOGIC;
           b5 : out  STD_LOGIC;
           b6 : out  STD_LOGIC;
           b7 : out  STD_LOGIC;
           en : in  STD_LOGIC);
end decoder_com_enable;

architecture Behavioral of decoder_com_enable is

begin
	
		b0 <= en and not a2 and not a1 and not a0;  -- a = 000
		b1 <= en and not a2 and not a1 and     a0;  -- a = 001
		b2 <= en and not a2 and     a1 and not a0;  -- a = 010
		b3 <= en and not a2 and     a1 and     a0;  -- a = 011
		b4 <= en and     a2 and not a1 and not a0;  -- a = 100
		b5 <= en and     a2 and not a1 and     a0;  -- a = 101
		b6 <= en and     a2 and     a1 and not a0;  -- a = 110
		b7 <= en and     a2 and     a1 and     a0;  -- a = 111

end Behavioral;
