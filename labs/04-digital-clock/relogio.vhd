----------------------------------------------------------------------------------
-- LAB 4 - Projeto 1 - RELOGIO DIGITAL (top-level estrutural)
--
--    clk, rst, pausa, conf --> TEMPORIZADOR --> 4 digitos BCD --> DRIVER SSD --> SSDs
--
-- DIV_SEG e DIV_REF sao repassados aos componentes. Os valores padrao valem para
-- o clock de 50 MHz da Nexys 2; o testbench os reduz para encurtar a simulacao.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity relogio is
    generic ( DIV_SEG : integer := 50000000;    -- ciclos de clk por segundo
              DIV_REF : integer := 50000 );     -- ciclos de clk por digito
    Port ( clk   : in  STD_LOGIC;
           rst   : in  STD_LOGIC;
           pausa : in  STD_LOGIC;
           conf  : in  STD_LOGIC;
           dig   : out STD_LOGIC_VECTOR (6 downto 0);
           an    : out STD_LOGIC_VECTOR (3 downto 0));
end relogio;

architecture Estrutural of relogio is

   component temporizador
      generic ( DIV_SEG : integer );
      Port ( clk   : in  STD_LOGIC;
             rst   : in  STD_LOGIC;
             pausa : in  STD_LOGIC;
             conf  : in  STD_LOGIC;
             dmin  : out STD_LOGIC_VECTOR (3 downto 0);
             umin  : out STD_LOGIC_VECTOR (3 downto 0);
             dseg  : out STD_LOGIC_VECTOR (3 downto 0);
             useg  : out STD_LOGIC_VECTOR (3 downto 0));
   end component;

   component driver_ssd
      generic ( DIV_REF : integer );
      Port ( clk  : in  STD_LOGIC;
             rst  : in  STD_LOGIC;
             dmin : in  STD_LOGIC_VECTOR (3 downto 0);
             umin : in  STD_LOGIC_VECTOR (3 downto 0);
             dseg : in  STD_LOGIC_VECTOR (3 downto 0);
             useg : in  STD_LOGIC_VECTOR (3 downto 0);
             dig  : out STD_LOGIC_VECTOR (6 downto 0);
             an   : out STD_LOGIC_VECTOR (3 downto 0));
   end component;

   -- sinais internos que ligam um componente ao outro
   signal s_dmin : STD_LOGIC_VECTOR (3 downto 0);
   signal s_umin : STD_LOGIC_VECTOR (3 downto 0);
   signal s_dseg : STD_LOGIC_VECTOR (3 downto 0);
   signal s_useg : STD_LOGIC_VECTOR (3 downto 0);

begin

   U1: temporizador
       generic map ( DIV_SEG => DIV_SEG )
       port map ( clk   => clk,
                  rst   => rst,
                  pausa => pausa,
                  conf  => conf,
                  dmin  => s_dmin,
                  umin  => s_umin,
                  dseg  => s_dseg,
                  useg  => s_useg );

   U2: driver_ssd
       generic map ( DIV_REF => DIV_REF )
       port map ( clk  => clk,
                  rst  => rst,
                  dmin => s_dmin,
                  umin => s_umin,
                  dseg => s_dseg,
                  useg => s_useg,
                  dig  => dig,
                  an   => an );

end Estrutural;
