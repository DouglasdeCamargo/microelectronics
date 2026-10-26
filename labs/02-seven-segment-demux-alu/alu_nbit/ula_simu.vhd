--------------------------------------------------------------------------------
-- VHDL Test Bench for module: ula   (N = 2)
-- a e b em complemento de 2: "00"=0, "01"=+1, "10"=-2, "11"=-1
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY ula_simu IS
END ula_simu;

ARCHITECTURE behavior OF ula_simu IS

    COMPONENT ula
    GENERIC ( N : integer );
    PORT(
         enable   : IN  std_logic;
         a        : IN  std_logic_vector(1 downto 0);
         b        : IN  std_logic_vector(1 downto 0);
         opcode   : IN  std_logic_vector(2 downto 0);
         y        : OUT std_logic_vector(1 downto 0);
         cout     : OUT std_logic;
         overflow : OUT std_logic
        );
    END COMPONENT;

   signal enable   : std_logic := '0';
   signal a        : std_logic_vector(1 downto 0) := "00";
   signal b        : std_logic_vector(1 downto 0) := "00";
   signal opcode   : std_logic_vector(2 downto 0) := "000";
   signal y        : std_logic_vector(1 downto 0);
   signal cout     : std_logic;
   signal overflow : std_logic;

BEGIN

   uut: ula GENERIC MAP ( N => 2 )
            PORT MAP ( enable => enable, a => a, b => b, opcode => opcode,
                       y => y, cout => cout, overflow => overflow );

   stim_proc: process
   begin
      -- ---- enable desligado: saidas zeradas qualquer que seja a operacao ----
      enable <= '0'; a <= "01"; b <= "01"; opcode <= "000"; wait for 40 ns;
      opcode <= "100"; wait for 40 ns;

      -- ---- 000: soma ----
      enable <= '1'; opcode <= "000";
      a <= "01"; b <= "01"; wait for 40 ns;   -- +1 +1 = +2 -> y=10, OVERFLOW
      a <= "01"; b <= "11"; wait for 40 ns;   -- +1 -1 =  0 -> y=00, cout=1
      a <= "11"; b <= "11"; wait for 40 ns;   -- -1 -1 = -2 -> y=10, cout=1
      a <= "10"; b <= "11"; wait for 40 ns;   -- -2 -1 = -3 -> OVERFLOW

      -- ---- 001: subtracao ----
      opcode <= "001";
      a <= "01"; b <= "01"; wait for 40 ns;   -- +1 - +1 =  0 -> y=00
      a <= "00"; b <= "01"; wait for 40 ns;   --  0 - +1 = -1 -> y=11, borrow=1
      a <= "01"; b <= "11"; wait for 40 ns;   -- +1 - -1 = +2 -> OVERFLOW

      -- ---- operacoes logicas: cout e overflow sempre '0' ----
      a <= "10"; b <= "11";
      opcode <= "010"; wait for 40 ns;        -- and  -> 10
      opcode <= "011"; wait for 40 ns;        -- or   -> 11
      opcode <= "100"; wait for 40 ns;        -- xor  -> 01
      opcode <= "101"; wait for 40 ns;        -- not a -> 01

      -- ---- incremento e decremento ----
      opcode <= "110";
      a <= "00"; wait for 40 ns;              --  0 +1 = +1 -> y=01
      a <= "01"; wait for 40 ns;              -- +1 +1 = +2 -> OVERFLOW
      a <= "11"; wait for 40 ns;              -- -1 +1 =  0 -> y=00, cout=1

      opcode <= "111";
      a <= "01"; wait for 40 ns;              -- +1 -1 =  0 -> y=00
      a <= "00"; wait for 40 ns;              --  0 -1 = -1 -> y=11, borrow=1
      a <= "10"; wait for 40 ns;              -- -2 -1 = -3 -> OVERFLOW
      wait;
   end process;

END;
