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
    -- constant nb_Neurones : integer := 100;
    signal mult1  , mult2   : typtabcst(0 to lngimag-1);  -- Signaux Multiplieurs
    signal mult1_L, mult2_L : typtabcst(0 to lngimag-1);  -- Signaux Registre Multiplieurs
    
    signal add1  , add2     : typtabaccu; -- Signaux Additionneurs
    signal add1_L, add2_L   : typtabaccu;  -- Signaux Registre Additionneurs

    signal activf1  , activf2   : typtabaccu; -- Signaux fonctions d'activation
    signal activf1_L, activf2_L : typtabaccu; -- Signaux Registre fonctions d'activation

	signal clkimg2 : std_logic := '0';
	signal pixelin : sfixed(0 downto -nbitq) := (others => '0');
begin
	ready <= '1';
	process (clock, reset) is
	begin
		if reset = '0' then
			clkimg2 <= '0';
		elsif rising_edge(clock) then
			clkimg2 <= clkimg;
		end if;
	end process;

    -------------------------- Resynchro de image sur clock ---------------------------------
	process (clock, reset) is
	begin
		if reset = '0' then
			pixelin <= (others => '0');
		elsif rising_edge(clock) then
			if clkimg = '1' and clkimg2 = '0' then -- rising edge
				pixelin <= sfixed('0' & image);
			end if;
		end if;
	end process;

    -------------------------- Etages de registres ---------------------------------
    process(clock)
    begin
        if rising_edge(clock) then
            mult1_L <= mult1;
            mult2_L <= mult2;

            add1_L <= add1;
            add2_L <= add2;

            activf1_L <= activf1;
            activf2_L <= activf2;
        end if;
    end process;

    -------------------------- Calculs neurones couche 1 ---------------------------------

    gen_Mult_1e : for i in 0 to (allcoef1'length-1) generate
        mult1(i) <= resize(allcoef1(i) * pixelin * to_sfixed(ccf, 5, 0), mult1(i), fixed_wrap, fixed_truncate);
    end generate;

    gen_Add_1e : for i in 0 to (allcoef1'length-1) generate
        add1(i) <= resize( mult1_L(i) + to_sfixed(cct, 6, 0), add1(i), fixed_wrap, fixed_truncate);
    end generate;

    -------------------------- Fonction d'activation 1 ---------------------------------

    gen_FctActiv_1e : for i in 0 to (allcoef1'length-1) generate
		activf1(i) <= to_sfixed(1, activf1(i)) when add1_L(i) > 2 else
					  to_sfixed(-1, activf1(i)) when add1_L(i) < -2 else
					  resize(shift_right(add1_L(i), 1), activf1(i), fixed_wrap, fixed_truncate);
    end generate;

    -------------------------- Calculs neurones couche 2 ---------------------------------

    gen_Mult_2e : for i in 0 to (allcoef1'length-1) generate
        mult2(i) <= resize(allcoef2(i) * activf1_L(i) * to_sfixed(ccf2, 5, 0), mult2(i), fixed_wrap, fixed_truncate);
    end generate;

    gen_Add_2e : for i in 0 to (allcoef1'length-1) generate
        add2(i) <= resize( mult2_L(i) + to_sfixed(cct2, 6, 0), add2(i), fixed_wrap, fixed_truncate);
    end generate;


    -------------------------- Fonction d'activation 2 ---------------------------------

    gen_FctActiv_2e : for i in 0 to (allcoef1'length-1) generate
    end generate;
end architecture;
