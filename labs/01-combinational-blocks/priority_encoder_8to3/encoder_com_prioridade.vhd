----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:03:14 09/11/2026 
-- Design Name: 
-- Module Name:    encoder_com_prioridade - Behavioral 
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

entity encoder_com_prioridade is
    Port ( x7 : in  STD_LOGIC;
           x6 : in  STD_LOGIC;
           x5 : in  STD_LOGIC;
           x4 : in  STD_LOGIC;
           x3 : in  STD_LOGIC;
           x2 : in  STD_LOGIC;
           x1 : in  STD_LOGIC;
           y2 : out  STD_LOGIC;
           y1 : out  STD_LOGIC;
           y0 : out  STD_LOGIC);
end encoder_com_prioridade;

architecture Behavioral of encoder_com_prioridade is

begin
	y2 <= x7 or x6 or x5 or x4;

   y1 <= x7 or x6 or (not x5 and not x4 and (x3 or x2));

   y0 <= x7 or (not x6 and x5) or (not x6 and not x4 and x3) or (not x6 and not x4 and not x2 and x1);

end Behavioral;
