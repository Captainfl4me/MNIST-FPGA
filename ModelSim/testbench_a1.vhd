---------------------------------------------------------
-- Ce programme a été développé à CENTRALESUPELEC
-- Merci de conserver ce cartouche
-- Copyright  (c) 2021  CENTRALESUPELEC   
-- Département Systèmes électroniques
-- ------------------------------------------------------
--
-- fichier : testbench_a1.vhd
-- auteur  : P.BENABES   
-- Copyright (c) 2021 CENTRALE-SUPELEC
-- Revision: 1.0  Date: 04/01/2021
--
---------------------------------------------------------
---------------------------------------------------------
--
-- DESCRIPTION DU CODE :
-- ce module est le plus haut niveau du testbench de la pll 
-- il connecte le DCO, la partie digitale, et le generateur de signaux de test
--
----------------------------------------------------------

architecture a1 of testbench is

----------------------------------------------------
-- tous les composants a connecter
----------------------------------------------------
component digital_gene IS
	GENERIC (    nbimag : integer := 100;       -- nombre d'images dans le fichier de test
				 numimag : integer := 1;        -- numéro de la première image envoyée dans le test
				 lngimag : integer := 784;		-- longueur d'une image 
				 nbsymbol : integer := 10;		-- nombre de symboles à détecter
				 clock_period : time := 100 ns  -- periode d'horloge
    ) ;    
    PORT(
        ready      : IN std_logic;				-- reset de la logique
        reset      : OUT std_logic;				-- reset de la logique
        clock      : OUT std_logic;				-- horloge systeme
        start	   : OUT std_logic;				-- demarrage de l'image
        clkimg     : OUT std_logic;				-- horloge systeme
		image      : OUT unsigned(7 downto 0);   -- contenu des pixels
		nbimage    : OUT integer;   			-- numero de l'image
		labl	   : OUT integer range 0 to nbsymbol   -- chiffre attendu
    );
end component;

component neurone1 IS
    PORT(
        reset      : IN std_logic;				-- reset de la logique
        clock      : IN std_logic;				-- horloge systeme
        start	   : IN std_logic;				-- demarrage de l'image
        clkimg     : IN std_logic;				-- horloge image
		image      : IN unsigned(7 downto 0);   -- facteur de division
		numaffich  : IN unsigned(2 downto 0);    -- numero de l'afficheur traité
--		labl       : OUT typlabel;   -- label du chiffre reconnu 
		labl       : OUT unsigned(19 downto 0) ;  -- label du chiffre reconnu 
		labl2       : OUT unsigned(19 downto 0) ; -- label du chiffre reconnu 
		valid       : OUT std_logic_vector(4 downto 0) ; -- label du chiffre reconnu 
        ready      : OUT std_logic				-- pret à recevoir le pixel suivant
    );
END component;


---------------------------------
-- tous les signaux locaux
---------------------------------

signal reset,clock,clkimg,start,ready : std_logic ;	 -- reset et horloges
signal image : unsigned(7 downto 0) ;		-- facteur de division
signal labl	 : integer range 0 to 10 ; -- chiffre attendu
signal labout,labout2	 : unsigned(19 downto 0) ; -- chiffres obtenus
signal valid : std_logic_vector(4 downto 0) ; -- indique si la reconaissance est valide 

signal nbimage : integer ;
signal numaffich : unsigned(2 downto 0) ;
signal labl1,labl2,labl3,labl4,labl5 : integer range 0 to 15 ;

type typtab1 is array(1 to 2) of integer ;
type typtab2 is array(1 to 2,1 to 2) of integer ;


constant  tab1 : typtab1 :=(0, 1);
constant  tab2 : typtab2 :=((0, 1), (2, 3)) ;

begin

-- instantiation de tous les composants
----------------------------------------

numaffich <= to_unsigned( (nbimage+4) mod 5,numaffich'length) ;

c1 : digital_gene generic map (100,1,784,10,100 ns) port map(ready,reset,clock,start,clkimg,image,nbimage,labl);
DP : neurone1 port map(reset,clock,start,clkimg,image,numaffich,labout,labout2,valid,ready);

labl1 <= to_integer(labout(3 downto 0));
labl2 <= to_integer(labout(7 downto 4));
labl3 <= to_integer(labout(11 downto 8));
labl4 <= to_integer(labout(15 downto 12));
labl5 <= to_integer(labout(19 downto 16));

end architecture a1 ;
