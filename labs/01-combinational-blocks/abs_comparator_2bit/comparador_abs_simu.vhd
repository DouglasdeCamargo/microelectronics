--------------------------------------------------------------------------------
-- VHDL Test Bench for module: comparador_abs
-- Varre as 16 combinacoes de (a,b)
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY comparador_abs_simu IS
END comparador_abs_simu;

ARCHITECTURE behavior OF comparador_abs_simu IS

    COMPONENT comparador_abs
    PORT(
         a1 : IN  std_logic;
         a0 : IN  std_logic;
         b1 : IN  std_logic;
         b0 : IN  std_logic;
         s  : OUT std_logic
        );
    END COMPONENT;

   --Inputs
   signal a1 : std_logic := '0';
   signal a0 : std_logic := '0';
   signal b1 : std_logic := '0';
   signal b0 : std_logic := '0';

   --Outputs
   signal s : std_logic;

BEGIN

   uut: comparador_abs PORT MAP (
          a1 => a1,
          a0 => a0,
          b1 => b1,
          b0 => b0,
          s  => s
        );

   stim_proc: process
   begin                                                     --   a    b   s
      a1<='0'; a0<='0'; b1<='0'; b0<='0'; wait for 50 ns;    --   0    0   1
      a1<='0'; a0<='0'; b1<='0'; b0<='1'; wait for 50 ns;    --   0   +1   0
      a1<='0'; a0<='0'; b1<='1'; b0<='0'; wait for 50 ns;    --   0   -2   0
      a1<='0'; a0<='0'; b1<='1'; b0<='1'; wait for 50 ns;    --   0   -1   0
      a1<='0'; a0<='1'; b1<='0'; b0<='0'; wait for 50 ns;    --  +1    0   0
      a1<='0'; a0<='1'; b1<='0'; b0<='1'; wait for 50 ns;    --  +1   +1   1
      a1<='0'; a0<='1'; b1<='1'; b0<='0'; wait for 50 ns;    --  +1   -2   0
      a1<='0'; a0<='1'; b1<='1'; b0<='1'; wait for 50 ns;    --  +1   -1   1
      a1<='1'; a0<='0'; b1<='0'; b0<='0'; wait for 50 ns;    --  -2    0   0
      a1<='1'; a0<='0'; b1<='0'; b0<='1'; wait for 50 ns;    --  -2   +1   0
      a1<='1'; a0<='0'; b1<='1'; b0<='0'; wait for 50 ns;    --  -2   -2   1
      a1<='1'; a0<='0'; b1<='1'; b0<='1'; wait for 50 ns;    --  -2   -1   0
      a1<='1'; a0<='1'; b1<='0'; b0<='0'; wait for 50 ns;    --  -1    0   0
      a1<='1'; a0<='1'; b1<='0'; b0<='1'; wait for 50 ns;    --  -1   +1   1
      a1<='1'; a0<='1'; b1<='1'; b0<='0'; wait for 50 ns;    --  -1   -2   0
      a1<='1'; a0<='1'; b1<='1'; b0<='1'; wait for 50 ns;    --  -1   -1   1
      wait;
   end process;

END;
