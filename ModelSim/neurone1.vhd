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
    signal mult1 : typtabcst(0 to nbneuron-1);  -- Signaux Multiplieurs
	signal mult2 : typtabcst(0 to nbsymbol-1);
    
    signal add1 : typtabaccu; -- Signaux Additionneurs
    signal add2 : typtabaccu2;  -- Signaux Registre Additionneurs

    signal activf1 : typtabaccu; -- Signaux fonctions d'activation
    signal activf2 : typtabaccu2; -- Signaux Registre fonctions d'activation

	type state is (sm_reset, sm_compute, sm_wait_start);
	signal cur_state : state := sm_reset;

	signal pixel_index     : integer range 0 to lngimag-1  := 0;
	signal neuron_index    : integer range 0 to nbneuron-1 := 0;
	signal clkimg2, start2 : std_logic := '0';
	signal pixelin         : sfixed(0 downto -nbitq) := (others => '0');
begin
	ready <= '1';
	process (clock, reset) is
	begin
		if reset = '0' then
			clkimg2 <= '0';
			start2 <= '0';
		elsif rising_edge(clock) then
			clkimg2 <= clkimg;
			start2 <= start;
		end if;
	end process;

    -------------------------- State detection ---------------------------------
	process (clock, reset) is
	begin
		if reset = '0' then
			cur_state <= sm_reset;
		elsif rising_edge(clock) then
			case cur_state is
				when sm_reset => cur_state <= sm_compute;
				when sm_compute => 
					if start = '1' and start2 = '0' then -- rising edge
						cur_state <= sm_reset;
					elsif  pixel_index >= lngimag-1 then 
						cur_state <= sm_wait_start; 
					end if;
				when sm_wait_start =>
					if start = '1' and start2 = '0' then -- rising edge
						cur_state <= sm_reset;
					end if;
			end case;
		end if;
	end process;

    -------------------------- Resynchro de image sur clock & Compteur index pixel ---------------------------------
	process (clock, reset) is
	begin
		if reset = '0' then
			pixelin <= (others => '0');
			pixel_index <= 0;
		elsif rising_edge(clock) then
			if clkimg = '1' and clkimg2 = '0' then -- rising edge
				pixelin <= sfixed('0' & image);

				if cur_state = sm_compute then
					pixel_index <= pixel_index + 1;
				else
					pixel_index <= 0;
				end if;
			end if;
		end if;
	end process;

    -------------------------- Calculs neurones couche 1 ---------------------------------

    gen_Mult_1e : for i in 0 to (mult1'length-1) generate
        mult1(i) <= resize(coef1(pixel_index, i) * pixelin * to_sfixed(ccf, 5, 0), mult1(i), fixed_wrap, fixed_truncate);
    end generate;

    gen_Add_1e : for i in 0 to (add1'length-1) generate
        add1(i) <= resize(add1(i) + mult1(i) + to_sfixed(cct, 6, 0), add1(i), fixed_wrap, fixed_truncate);
    end generate;

    -------------------------- Fonction d'activation 1 ---------------------------------

    gen_FctActiv_1e : for i in 0 to (add1'length-1) generate
		activf1(i) <= to_sfixed(1, activf1(i)) when add1(i) > 2 else
					  to_sfixed(-1, activf1(i)) when add1(i) < -2 else
					  resize(shift_right(add1(i), 1), activf1(i), fixed_wrap, fixed_truncate);
    end generate;

    -------------------------- Calculs neurones couche 2 ---------------------------------

    gen_Mult_2e : for i in 0 to (mult2'length-1) generate
        mult2(i) <= resize(coef2(neuron_index, i) * activf1(i) * to_sfixed(ccf2, 5, 0), mult2(i), fixed_wrap, fixed_truncate);
    end generate;

    gen_Add_2e : for i in 0 to (add2'length-1) generate
        add2(i) <= resize(add2(i) + mult2(i) + to_sfixed(cct2, 6, 0), add2(i), fixed_wrap, fixed_truncate);
    end generate;


    -------------------------- Fonction d'activation 2 ---------------------------------

    process_2e_Activation : process(add2)
        variable maxT, maxT2 : sfixed(5 downto -nbitq) := to_sfixed(0, 5, -nbitq);  -- Les 2 maximums du réseau
        variable maxI, maxI2 : integer range 0 to nbsymbol := 0;	                              -- Indices des neurones maximum
    begin
        for i in 0 to (add2'length-1) loop
            if add2(i) > maxT then
                maxT2 := maxT;
                maxI2 := maxI;
                maxI  := i;
                maxT  := resize(add2(i), maxT, fixed_wrap, fixed_truncate); 
            elsif add2(i) > maxT2 then
                maxI2 := i;
                maxT2 := resize(add2(i), maxT2, fixed_wrap, fixed_truncate); 
            end if;
        end loop;

        labl(to_integer(numaffich)*4+3 downto to_integer(numaffich)*4)  <= to_unsigned(maxI, 4);	
        labl2(to_integer(numaffich)*4+3 downto to_integer(numaffich)*4) <= to_unsigned(maxI2, 4);	

        if maxT > maxT2*1.5 then
            valid(to_integer(numaffich)) <= '1'; 
        else 
            valid(to_integer(numaffich)) <= '0'; 
        end if;
    end process;
end architecture;
