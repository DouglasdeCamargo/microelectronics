--------------------------------------------------------------------------------
-- Testbench do componente TEMPORIZADOR
--
-- DIV_SEG = 2 e clk de 20 ns: cada "segundo" dura 40 ns, o que permite observar
-- a virada de minuto em poucos microssegundos. Os quatro digitos BCD aparecem
-- diretamente na forma de onda, o que torna a leitura mais facil do que no
-- top-level, onde eles estao multiplexados.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY temporizador_simu IS
END temporizador_simu;

ARCHITECTURE behavior OF temporizador_simu IS

    COMPONENT temporizador
    GENERIC ( DIV_SEG : integer );
    PORT( clk   : IN  std_logic;
          rst   : IN  std_logic;
          pausa : IN  std_logic;
          conf  : IN  std_logic;
          dmin  : OUT std_logic_vector(3 downto 0);
          umin  : OUT std_logic_vector(3 downto 0);
          dseg  : OUT std_logic_vector(3 downto 0);
          useg  : OUT std_logic_vector(3 downto 0) );
    END COMPONENT;

   signal clk   : std_logic := '0';
   signal rst   : std_logic := '0';
   signal pausa : std_logic := '0';
   signal conf  : std_logic := '0';
   signal dmin  : std_logic_vector(3 downto 0);
   signal umin  : std_logic_vector(3 downto 0);
   signal dseg  : std_logic_vector(3 downto 0);
   signal useg  : std_logic_vector(3 downto 0);

   constant PERIODO : time := 20 ns;

BEGIN

   uut: temporizador GENERIC MAP ( DIV_SEG => 2 )
                     PORT MAP ( clk => clk, rst => rst, pausa => pausa, conf => conf,
                                dmin => dmin, umin => umin, dseg => dseg, useg => useg );

   -- gerador de clock
   clk <= not clk after PERIODO/2;

   stim_proc: process
   begin
      -- ---- reset inicial: todos os digitos em zero ----
      rst <= '1';
      wait for 100 ns;
      rst <= '0';

      -- ---- contagem normal de segundos (conf = '0': minutos e segundos) ----
      wait for 500 ns;                 -- cerca de 12 segundos

      -- ---- pausa: os digitos param, sem zerar ----
      pausa <= '1';
      wait for 300 ns;
      pausa <= '0';

      -- ---- segue contando ate passar de 59 s e virar o minuto ----
      wait for 2500 ns;

      -- ---- conf = '1': passa a mostrar horas e minutos ----
      conf <= '1';
      wait for 400 ns;
      conf <= '0';
      wait for 200 ns;

      -- ---- reset tem precedencia mesmo com a pausa ativa ----
      pausa <= '1';
      wait for 100 ns;
      rst <= '1';
      wait for 100 ns;
      rst <= '0';
      wait for 200 ns;

      wait;
   end process;

END;
