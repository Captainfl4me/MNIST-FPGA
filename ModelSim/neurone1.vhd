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
    signal mult1  , mult2,  : typtabcst;  -- Signaux Multiplieurs
    signal mult1_L, mult2_L : typtabcst;  -- Signaux Registre Multiplieurs
    
    signal add1  , add2     : typtabaccu; -- Signaux Additionneurs
    signal add1_L, add2_L   : typtabaccu;  -- Signaux Registre Additionneurs

    signal activf1  , activf2   : typtabaccu; -- Signaux fonctions d'activation
    signal activf1_L, activf2_L : typtabaccu; -- Signaux Registre fonctions d'activation

begin

    process(clk)
    begin
        if rising_edge(clk) then
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
        mult1(i) <= sfixed(allcoef1(i) * image * ccf, mult1(i), fixed_wrap, fixed_truncate);
    end generate;

    gen_Add_1e : for i in 0 to (mult1_L'length-1) generate
        add1(i) <= sfixed( mult1_L(i) + cct, add1(i), fixed_wrap, fixed_truncate);
    end generate;

    -------------------------- Fonction d'activation 1 ---------------------------------

    gen_FctActiv_1e : for i in 0 to (add1_L'length-1) generate
        if add1_L(i) > 2 then
            activf1(i) <= sfixed(1, activf1(i), fixed_wrap, fixed_truncate);
        elsif add1_L(i) < -2 then
            activf1(i) <= sfixed(-1, activf1(i), fixed_wrap, fixed_truncate);
        else 
            activf1(i) <= sfixed(add1_L/2.0, activf1(i), fixed_wrap, fixed_truncate);
        end if;   
    end generate;

    -------------------------- Calculs neurones couche 2 ---------------------------------

    gen_Mult_2e : for i in 0 to (allcoef2'length-1) generate
        mult2(i) <= sfixed(allcoef2(i) * activf1_L(i)) * ccf2, mult2(i), fixed_wrap, fixed_truncate);
    end generate;

    gen_Add_2e : for i in 0 to (mult2_L'length-1) generate
        add2(i) <= sfixed( mult2_L(i) + cct2, add2(i), fixed_wrap, fixed_truncate);
    end generate;


    -------------------------- Fonction d'activation 2 ---------------------------------

    process_2e_ Activation : process(add2_L)
        variable maxT, maxT2 : sfixed(5 downto -nbitq) := to_sfixed(0, 5 downto -nbitq);  -- Les 2 maximums du réseau
        variable maxI, maxI2 : integer range 0 to nbsymbol;	                              -- Indices des neurones maximum
    begin
        for i in 0 to (add2_L'length-1) loop
            if add2_L(i) > maxT then
                maxT2 <= maxT;
                maxI2 <= maxI;
                maxI <= i;
                maxT  <= resize(add2_L(i), maxT, fixed_wrap, fixed_truncate); 

            elsif add2_L(i) > maxT2 then
                maxI2 <= i;
                maxT2 <= resize(add2_L(i), maxT2, fixed_wrap, fixed_truncate); 

            end if;
        end loop;

        labl(to_integer(numaffich)*4+3 downto to_integer(numaffich)*4) <= to_unsigned(maxI,4) ;	
        labl2(to_integer(numaffich)*4+3 downto to_integer(numaffich)*4) <= to_unsigned(maxI2,4);	

        if max > max2*1.5 then
            valid(to_integer(numaffich)) <= '1'; 
        else 
            valid(to_integer(numaffich)) <= '0'; 
        end if;

    end process proc_name;
    

end architecture;