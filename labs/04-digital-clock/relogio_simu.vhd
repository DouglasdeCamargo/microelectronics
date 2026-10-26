--------------------------------------------------------------------------------
-- Testbench do RELOGIO DIGITAL (top-level)
--
-- Mostra os dois componentes trabalhando juntos: o anodo percorre os quatro
-- displays e os segmentos mudam conforme o digito da vez.
-- DIV_SEG = 2 e DIV_REF = 1 encurtam a simulacao.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY relogio_simu IS
END relogio_simu;

ARCHITECTURE behavior OF relogio_simu IS

    COMPONENT relogio
    GENERIC ( DIV_SEG : integer;
              DIV_REF : integer );
    PORT( clk   : IN  std_logic;
          rst   : IN  std_logic;
          pausa : IN  std_logic;
          conf  : IN  std_logic;
          dig   : OUT std_logic_vector(6 downto 0);
          an    : OUT std_logic_vector(3 downto 0) );
    END COMPONENT;

   signal clk   : std_logic := '0';
   signal rst   : std_logic := '0';
   signal pausa : std_logic := '0';
   signal conf  : std_logic := '0';
   signal dig   : std_logic_vector(6 downto 0);
   signal an    : std_logic_vector(3 downto 0);

   constant PERIODO : time := 20 ns;

BEGIN

   uut: relogio GENERIC MAP ( DIV_SEG => 2, DIV_REF => 1 )
                PORT MAP ( clk => clk, rst => rst, pausa => pausa, conf => conf,
                           dig => dig, an => an );

   clk <= not clk after PERIODO/2;

   stim_proc: process
   begin
      rst <= '1';
      wait for 100 ns;
      rst <= '0';

      -- varredura dos quatro displays com o relogio correndo
      wait for 900 ns;

      -- pausa
      pausa <= '1';
      wait for 300 ns;
      pausa <= '0';

      -- troca de exibicao
      conf <= '1';
      wait for 400 ns;
      conf <= '0';
      wait for 300 ns;

      wait;
   end process;

END;
