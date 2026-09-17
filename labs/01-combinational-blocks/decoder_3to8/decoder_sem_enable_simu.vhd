--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   01:04:13 09/11/2026
-- Design Name:   
-- Module Name:   /projects/LAB1/decoder_sem_enable_simu.vhd
-- Project Name:  LAB1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: decoder_sem_enable
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY decoder_sem_enable_simu IS
END decoder_sem_enable_simu;
 
ARCHITECTURE behavior OF decoder_sem_enable_simu IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT decoder_sem_enable
    PORT(
         a0 : IN  std_logic;
         a1 : IN  std_logic;
         a2 : IN  std_logic;
         b0 : OUT  std_logic;
         b1 : OUT  std_logic;
         b2 : OUT  std_logic;
         b3 : OUT  std_logic;
         b4 : OUT  std_logic;
         b5 : OUT  std_logic;
         b6 : OUT  std_logic;
         b7 : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal a0 : std_logic := '0';
   signal a1 : std_logic := '0';
   signal a2 : std_logic := '0';

 	--Outputs
   signal b0 : std_logic;
   signal b1 : std_logic;
   signal b2 : std_logic;
   signal b3 : std_logic;
   signal b4 : std_logic;
   signal b5 : std_logic;
   signal b6 : std_logic;
   signal b7 : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
  
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: decoder_sem_enable PORT MAP (
          a0 => a0,
          a1 => a1,
          a2 => a2,
          b0 => b0,
          b1 => b1,
          b2 => b2,
          b3 => b3,
          b4 => b4,
          b5 => b5,
          b6 => b6,
          b7 => b7
        );

  
 

   -- Stimulus process
   stim_proc: process
   begin		
      
        a2<='0'; a1<='0'; a0<='0'; wait for 50 ns;        -- b0
        a2<='0'; a1<='0'; a0<='1'; wait for 50 ns;        -- b1
        a2<='0'; a1<='1'; a0<='0'; wait for 50 ns;        -- b2
        a2<='0'; a1<='1'; a0<='1'; wait for 50 ns;        -- b3
        a2<='1'; a1<='0'; a0<='0'; wait for 50 ns;        -- b4
        a2<='1'; a1<='0'; a0<='1'; wait for 50 ns;        -- b5
        a2<='1'; a1<='1'; a0<='0'; wait for 50 ns;        -- b6
        a2<='1'; a1<='1'; a0<='1'; wait for 50 ns;        -- b7
  

      wait;
   end process;

END;
