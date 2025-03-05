library ieee,work;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.ALL;

entity synth_neurone is
    port(
		reset      : in std_logic;				         -- reset de la logique
		clock      : in std_logic;				         -- horloge systeme
		start	     : in std_logic;				         -- demarrage de l'image
		clkimg     : in std_logic;				         -- horloge image
		image      : in unsigned(7 downto 0);            -- signal de l'image sous forme de pixel
		numaffich  : in unsigned(2 downto 0);            -- numero de l'afficheur traité
		labl       : out unsigned(19 downto 0) ;         -- label du chiffre reconnu 
		labl2      : out unsigned(19 downto 0) ;         -- label du chiffre reconnu 
		valid      : out std_logic_vector(4 downto 0) ;  -- label du chiffre reconnu 
		ready      : out std_logic				         -- pret à recevoir le pixel suivant
    );
end entity;


architecture a1 of synth_neurone is
	component neurone1 is
		 port(
			reset      : in std_logic;				         -- reset de la logique
			clock      : in std_logic;				         -- horloge systeme
			start	     : in std_logic;				         -- demarrage de l'image
			clkimg     : in std_logic;				         -- horloge image
			image      : in unsigned(7 downto 0);            -- signal de l'image sous forme de pixel
			numaffich  : in unsigned(2 downto 0);            -- numero de l'afficheur traité
			labl       : out unsigned(19 downto 0) ;         -- label du chiffre reconnu 
			labl2      : out unsigned(19 downto 0) ;         -- label du chiffre reconnu 
			valid      : out std_logic_vector(4 downto 0) ;  -- label du chiffre reconnu 
			ready      : out std_logic				         -- pret à recevoir le pixel suivant
		 );
	end component;
begin
	gen_neurone: neurone1
		port map(
			reset      => reset,
			clock      => clock,
			start	     => start, 
			clkimg     => clkimg,
			image      => image,
			numaffich  => numaffich,
			labl       => labl,
			labl2      => labl2,
			valid      => valid,
			ready      => ready
		);
end architecture;