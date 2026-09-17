--------------------------------------------------------------------------------
-- Project Name:  LAB1
-- Module Name:   /projects/LAB1/encoder_com_prioridade_simu.vhd
--
-- VHDL Test Bench for module: encoder_com_prioridade
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY encoder_com_prioridade_simu IS
END encoder_com_prioridade_simu;

ARCHITECTURE behavior OF encoder_com_prioridade_simu IS

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT encoder_com_prioridade
    PORT(
         x7 : IN  std_logic;
         x6 : IN  std_logic;
         x5 : IN  std_logic;
         x4 : IN  std_logic;
         x3 : IN  std_logic;
         x2 : IN  std_logic;
         x1 : IN  std_logic;
         y2 : OUT std_logic;
         y1 : OUT std_logic;
         y0 : OUT std_logic
        );
    END COMPONENT;

   --Inputs
   signal x7 : std_logic := '0';
   signal x6 : std_logic := '0';
   signal x5 : std_logic := '0';
   signal x4 : std_logic := '0';
   signal x3 : std_logic := '0';
   signal x2 : std_logic := '0';
   signal x1 : std_logic := '0';

   --Outputs
   signal y2 : std_logic;
   signal y1 : std_logic;
   signal y0 : std_logic;

BEGIN

   -- Instantiate the Unit Under Test (UUT)
   uut: encoder_com_prioridade PORT MAP (
          x7 => x7,
          x6 => x6,
          x5 => x5,
          x4 => x4,
          x3 => x3,
          x2 => x2,
          x1 => x1,
          y2 => y2,
          y1 => y1,
          y0 => y0
        );

   -- Stimulus process
   stim_proc: process
   begin

      -- uma entrada ativa por vez (linhas da tabela-verdade)
      x7<='0'; x6<='0'; x5<='0'; x4<='0'; x3<='0'; x2<='0'; x1<='0';
      wait for 40 ns;                                       -- y2y1y0 = 000
      x7<='0'; x6<='0'; x5<='0'; x4<='0'; x3<='0'; x2<='0'; x1<='1';
      wait for 40 ns;                                       -- y2y1y0 = 001
      x7<='0'; x6<='0'; x5<='0'; x4<='0'; x3<='0'; x2<='1'; x1<='0';
      wait for 40 ns;                                       -- y2y1y0 = 010
      x7<='0'; x6<='0'; x5<='0'; x4<='0'; x3<='1'; x2<='0'; x1<='0';
      wait for 40 ns;                                       -- y2y1y0 = 011
      x7<='0'; x6<='0'; x5<='0'; x4<='1'; x3<='0'; x2<='0'; x1<='0';
      wait for 40 ns;                                       -- y2y1y0 = 100
      x7<='0'; x6<='0'; x5<='1'; x4<='0'; x3<='0'; x2<='0'; x1<='0';
      wait for 40 ns;                                       -- y2y1y0 = 101
      x7<='0'; x6<='1'; x5<='0'; x4<='0'; x3<='0'; x2<='0'; x1<='0';
      wait for 40 ns;                                       -- y2y1y0 = 110
      x7<='1'; x6<='0'; x5<='0'; x4<='0'; x3<='0'; x2<='0'; x1<='0';
      wait for 40 ns;                                       -- y2y1y0 = 111

      -- varias entradas ativas: vence sempre a de maior prioridade
      x7<='0'; x6<='0'; x5<='0'; x4<='0'; x3<='0'; x2<='1'; x1<='1';
      wait for 40 ns;                                       -- x2 vence x1 -> 010
      x7<='0'; x6<='0'; x5<='0'; x4<='0'; x3<='1'; x2<='1'; x1<='1';
      wait for 40 ns;                                       -- x3 vence -> 011
      x7<='0'; x6<='0'; x5<='1'; x4<='1'; x3<='1'; x2<='1'; x1<='1';
      wait for 40 ns;                                       -- x5 vence -> 101
      x7<='1'; x6<='1'; x5<='1'; x4<='1'; x3<='1'; x2<='1'; x1<='1';
      wait for 40 ns;                                       -- x7 vence -> 111
      x7<='1'; x6<='0'; x5<='0'; x4<='0'; x3<='0'; x2<='0'; x1<='1';
      wait for 40 ns;                                       -- x7 vence x1 -> 111

      wait;
   end process;

END;
