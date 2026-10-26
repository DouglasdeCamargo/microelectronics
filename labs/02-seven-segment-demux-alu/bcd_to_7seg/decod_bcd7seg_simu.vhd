--------------------------------------------------------------------------------
-- VHDL Test Bench for module: decod_bcd7seg
-- Varre os 10 digitos BCD e tres combinacoes invalidas
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY decod_bcd7seg_simu IS
END decod_bcd7seg_simu;

ARCHITECTURE behavior OF decod_bcd7seg_simu IS

    COMPONENT decod_bcd7seg
    PORT(
         d   : IN  std_logic_vector(3 downto 0);
         seg : OUT std_logic_vector(6 downto 0);
         an  : OUT std_logic_vector(3 downto 0)
        );
    END COMPONENT;

   signal d   : std_logic_vector(3 downto 0) := "0000";
   signal seg : std_logic_vector(6 downto 0);
   signal an  : std_logic_vector(3 downto 0);

BEGIN

   uut: decod_bcd7seg PORT MAP ( d => d, seg => seg, an => an );

   stim_proc: process
   begin                                      -- seg = a b c d e f g  ('0' acende)
      d <= "0000"; wait for 40 ns;            -- 0 -> 0000001
      d <= "0001"; wait for 40 ns;            -- 1 -> 1001111
      d <= "0010"; wait for 40 ns;            -- 2 -> 0010010
      d <= "0011"; wait for 40 ns;            -- 3 -> 0000110
      d <= "0100"; wait for 40 ns;            -- 4 -> 1001100
      d <= "0101"; wait for 40 ns;            -- 5 -> 0100100
      d <= "0110"; wait for 40 ns;            -- 6 -> 0100000
      d <= "0111"; wait for 40 ns;            -- 7 -> 0001111
      d <= "1000"; wait for 40 ns;            -- 8 -> 0000000
      d <= "1001"; wait for 40 ns;            -- 9 -> 0000100
      d <= "1010"; wait for 40 ns;            -- invalido -> apagado
      d <= "1100"; wait for 40 ns;            -- invalido -> apagado
      d <= "1111"; wait for 40 ns;            -- invalido -> apagado
      wait;
   end process;

END;
