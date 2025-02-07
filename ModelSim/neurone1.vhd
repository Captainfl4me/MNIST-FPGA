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
    
    signal add1 : typtabaccu;   -- Signaux Additionneurs
    signal add2 : typtabaccu2;  -- Signaux Registre Additionneurs

    signal activf1, activf1_L : typtabaccu;  -- Signaux fonctions d'activation

    signal maxI_L, maxI2_L : integer range 0 to nbsymbol;

	type state is (sm_reset, sm_compute, sm_save, sm_wait_start);
	signal cur_state_m1 : state := sm_reset;
	signal cur_state_m2 : state := sm_reset;
	signal stage_1_reset : std_logic := '0';
	signal stage_2_reset : std_logic := '0';

	signal pixel_index     : integer range 0 to lngimag-1  := 0;
	signal pixel_index2    : integer range 0 to lngimag-1  := 0;
	signal neuron_index    : integer range 0 to nbneuron-1 := 0;
	signal clkimg2, start2 : std_logic := '0';
	signal pixelin         : sfixed(0 downto -nbitq) := (others => '0');
	signal pixelin2        : sfixed(0 downto -nbitq) := (others => '0');
	signal s_valid		   : std_logic_vector(4 downto 0) := (others => '0');
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
			cur_state_m1 <= sm_reset;
			cur_state_m2 <= sm_reset;
		elsif rising_edge(clock) then
			case cur_state_m1 is
				when sm_reset => 
					cur_state_m1 <= sm_compute;
				when sm_compute => 
					if start = '1' and start2 = '0' then -- rising edge
						cur_state_m1 <= sm_reset;
					elsif pixel_index2 >= lngimag-1 then 
						cur_state_m1 <= sm_save;
					end if;
				when sm_save =>
					cur_state_m1 <= sm_wait_start;
				when sm_wait_start =>
					if start = '1' and start2 = '0' then -- rising edge
						cur_state_m1 <= sm_reset;
					end if;
			end case;
			case cur_state_m2 is
				when sm_reset => cur_state_m2 <= sm_wait_start;
				when sm_compute => 
					if neuron_index >= nbneuron-1 then
						cur_state_m2 <= sm_save;	
					end if;
				when sm_save => cur_state_m2 <= sm_reset;
				when sm_wait_start => 
					if start = '1' and start2 = '0' then -- rising edge
						cur_state_m2 <= sm_reset;
					elsif cur_state_m1 = sm_save then
						cur_state_m2 <= sm_compute;
					end if;
			end case;
		end if;
	end process;
	stage_1_reset <= '0' when cur_state_m1 = sm_reset or reset = '0' else '1';
	stage_2_reset <= '0' when cur_state_m2 = sm_reset or reset = '0' else '1';

    -------------------------- Resynchro de image sur clock & Compteur index pixel ---------------------------------
	process (clock, reset) is
	begin
		if reset = '0' then
			pixelin <= (others => '0');
			pixel_index <= 0;
		elsif rising_edge(clock) then
			if clkimg = '1' and clkimg2 = '0' then -- rising edge
				pixelin <= sfixed('0' & image);

				if cur_state_m1 = sm_compute and pixel_index < lngimag-1 then
					pixel_index <= pixel_index + 1;
				else
					pixel_index <= 0;
				end if;
				pixelin2 <= pixelin;
			end if;

			if cur_state_m2 = sm_compute and neuron_index < nbneuron-1 then
				neuron_index <= neuron_index + 1;
			else
				neuron_index <= 0;
			end if;

			pixel_index2 <= pixel_index;
		end if;
	end process;

    -------------------------- Calculs neurones couche 1 ---------------------------------
    gen_Mult_1e : for i in 0 to (mult1'length-1) generate
        mult1(i) <= resize(coef1(pixel_index2, i) * pixelin2 * to_sfixed(ccf, 5, 0), mult1(i), fixed_wrap, fixed_truncate);
    end generate;


    gen_Add_1e : for i in 0 to (add1'length-1) generate
        gest_Accu1 : process(clock, stage_1_reset) is
        begin
            if stage_1_reset = '0' then
                add1(i) <= to_sfixed(0, add1(i), fixed_wrap, fixed_truncate );
            elsif rising_edge(clock) and clkimg = '1' and clkimg2 = '0' and cur_state_m1 = sm_compute then
                add1(i) <= resize(add1(i) + mult1(i) + to_sfixed(cct, 6, 0), add1(i), fixed_wrap, fixed_truncate);
            end if;
        end process;
    end generate;

    -------------------------- Fonction d'activation 1 ---------------------------------
    gen_FctActiv_1e : for i in 0 to (add1'length-1) generate
		activf1(i) <= to_sfixed(1, activf1(i)) when add1(i) > 2 else
					  to_sfixed(-1, activf1(i)) when add1(i) < -2 else
					  resize(shift_right(add1(i), 1), activf1(i), fixed_wrap, fixed_truncate);
    end generate;

    -------------------------- D Latch Mémoire ---------------------------------

    gen_Mem : process(clock, stage_1_reset) is
    begin
        if stage_1_reset = '0' then
            for i in 0 to (activf1_L'length-1) loop
                activf1_L(i) <= to_sfixed(0, activf1_L(i), fixed_wrap, fixed_truncate );
            end loop;
		elsif rising_edge(clock) and cur_state_m1 = sm_save then
            activf1_L <=  activf1;
        end if;
    end process;

    -------------------------- Calculs neurones couche 2 ---------------------------------
    gen_Mult_2e : for i in 0 to (mult2'length-1) generate
        mult2(i) <= resize(coef2(neuron_index, i) * activf1(i) * to_sfixed(ccf2, 5, 0), mult2(i), fixed_wrap, fixed_truncate);
    end generate;

    gen_Add_2e : for i in 0 to (add2'length-1) generate
        gest_Accu1 : process(clock, stage_1_reset) is
        begin
            if stage_1_reset = '0' then
                add2(i) <= to_sfixed(0, add2(i), fixed_wrap, fixed_truncate );
            elsif rising_edge(clock) and cur_state_m2 = sm_compute then
                add2(i) <= resize(add2(i) + mult2(i) + to_sfixed(cct2, 6, 0), add2(i), fixed_wrap, fixed_truncate);
            end if;
        end process;
    end generate;

    -------------------------- Fonction d'activation 2 ---------------------------------
    process_2e_Activation : process(add2)
        variable maxT, maxT2 : sfixed(5 downto -nbitq) := to_sfixed(0, 5, -nbitq);  -- Les 2 maximums du réseau
        variable maxI, maxI2 : integer range 0 to nbsymbol := 0;	                -- Indices des neurones maximum
    begin
		maxI := 0;
		maxI2 := 0;
		maxT := to_sfixed(0, 5, -nbitq);
		maxT2 := to_sfixed(0, 5, -nbitq);

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

        maxI_L  <= maxI;
        maxI2_L <= maxI2;

        if maxT > maxT2*1.5 then
            s_valid(to_integer(numaffich)) <= '1'; 
        else 
            s_valid(to_integer(numaffich)) <= '0'; 
        end if;
    end process;
	valid <= s_valid;

    -------------------------- D Latch Mémoire ---------------------------------
    gen_MemO : process (clock, reset)
    begin
        if reset = '0' then
            labl  <= (others => '0');	
            labl2 <= (others => '0');	
        elsif rising_edge(clock) and cur_state_m2 = sm_save then
            labl(to_integer(numaffich)*4+3 downto to_integer(numaffich)*4)  <= to_unsigned(maxI_L , 4);	
            labl2(to_integer(numaffich)*4+3 downto to_integer(numaffich)*4) <= to_unsigned(maxI2_L, 4);	
        end if;
    end process;
end architecture;
