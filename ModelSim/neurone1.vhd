library ieee,work;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.ALL;
use std.textio.all;
use ieee.fixed_pkg.all;
use ieee.fixed_float_types.all;
use work.coeff.all ;

entity neurone1 is
    port(
        reset      : in std_logic;				         -- reset de la logique
        clock      : in std_logic;				         -- horloge systeme
        start	   : in std_logic;				         -- demarrage de l'image
        clkimg     : in std_logic;				         -- horloge image
		image      : in unsigned(7 downto 0);            -- signal de l'image sous forme de pixel
		numaffich  : in unsigned(2 downto 0);            -- numero de l'afficheur traité
		labl       : out unsigned(19 downto 0) ;         -- label du chiffre reconnu 
		labl2      : out unsigned(19 downto 0) ;         -- label du chiffre reconnu 
		valid      : out std_logic_vector(4 downto 0) ;  -- label du chiffre reconnu 
        ready      : out std_logic				         -- pret à recevoir le pixel suivant
    );
end entity;


architecture a1 of neurone1 is
	signal clkimg2 : std_logic := '0';
	signal pixelin : unsigned(7 downto 0) := (others => '0');
begin
	ready <= '1';
	-- clkimg sync
	process (clock, reset) is
	begin
		if reset = '0' then
			clkimg2 <= '0';
		elsif rising_edge(clock) then
			clkimg2 <= clkimg;
		end if;
	end process;

	-- clkimg rising_edge detection
	process (clock, reset) is
	begin
		if reset = '0' then
			pixelin <= (others => '0');
		elsif rising_edge(clock) then
			if clkimg = '1' and clkimg2 = '0' then -- rising edge
				pixelin <= image;
			end if;
		end if;
	end process;

	-- Last stage

end architecture;
