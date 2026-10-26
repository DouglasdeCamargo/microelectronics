--------------------------------------------------------------------------------
-- VHDL Test Bench for module: demux1x8
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY demux1x8_simu IS
END demux1x8_simu;

ARCHITECTURE behavior OF demux1x8_simu IS

    COMPONENT demux1x8
    PORT(
         en  : IN  std_logic;
         d   : IN  std_logic;
         sel : IN  std_logic_vector(2 downto 0);
         y   : OUT std_logic_vector(7 downto 0)
        );
    END COMPONENT;

   signal en  : std_logic := '0';
   signal d   : std_logic := '0';
   signal sel : std_logic_vector(2 downto 0) := "000";
   signal y   : std_logic_vector(7 downto 0);

BEGIN

   uut: demux1x8 PORT MAP ( en => en, d => d, sel => sel, y => y );

   stim_proc: process
   begin
      -- enable desligado: saidas em zero, qualquer sel e qualquer d
      en <= '0'; d <= '1';
      sel <= "000"; wait for 40 ns;             -- y = 00000000
      sel <= "101"; wait for 40 ns;             -- y = 00000000

      -- enable ligado com d = '1': o '1' anda pelas oito saidas
      en <= '1'; d <= '1';
      sel <= "000"; wait for 40 ns;             -- y0
      sel <= "001"; wait for 40 ns;             -- y1
      sel <= "010"; wait for 40 ns;             -- y2
      sel <= "011"; wait for 40 ns;             -- y3
      sel <= "100"; wait for 40 ns;             -- y4
      sel <= "101"; wait for 40 ns;             -- y5
      sel <= "110"; wait for 40 ns;             -- y6
      sel <= "111"; wait for 40 ns;             -- y7

      -- com d = '0' nenhuma saida acende, mesmo com enable ativo
      d <= '0';
      sel <= "011"; wait for 40 ns;             -- y = 00000000
      sel <= "111"; wait for 40 ns;             -- y = 00000000

      -- volta com d = '1' para mostrar a transicao
      d <= '1';
      sel <= "010"; wait for 40 ns;             -- y2
      wait;
   end process;

END;
