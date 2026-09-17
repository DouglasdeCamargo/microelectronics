----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:45:10 09/11/2026 
-- Design Name: 
-- Module Name:    decoder_sem_enable - Behavioral 
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


entity decoder_sem_enable is
    Port ( a0 : in  STD_LOGIC;
           a1 : in  STD_LOGIC;
           a2 : in  STD_LOGIC;
           b0 : out  STD_LOGIC;
           b1 : out  STD_LOGIC;
           b2 : out  STD_LOGIC;
           b3 : out  STD_LOGIC;
           b4 : out  STD_LOGIC;
           b5 : out  STD_LOGIC;
           b6 : out  STD_LOGIC;
           b7 : out  STD_LOGIC);
end decoder_sem_enable;

architecture Behavioral of decoder_sem_enable is

begin

	b0 <= not a2 and not a1 and not a0; --a = 000
	b1 <= not a2 and not a1 and a0; --a = 001
	b2 <= not a2 and a1 and not a0;--a = 010
	b3 <= not a2 and a1 and a0; --a = 011
	b4 <= a2 and not a1 and not a0; --a = 100
	b5 <= a2 and not a1 and a0; --a = 101
	b6 <= a2 and a1 and not a0; --a = 110
	b7 <= a2 and a1 and a0; --a = 111

end Behavioral;
