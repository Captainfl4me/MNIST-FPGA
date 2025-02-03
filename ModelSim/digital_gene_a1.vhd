---------------------------------------------------------
-- Ce programme a t dvelopp  CENTRALESUPELEC
-- Merci de conserver ce cartouche
-- Copyright  (c) 2021  CENTRALESUPELEC   
-- Dpartement Systmes lectroniques
-- ------------------------------------------------------
--
-- fichier : digital_gene_a1.vhd
-- auteur  : P.BENABES   
-- Copyright (c) 2021 CENTRALE-SUPELEC
-- Revision: 1.0  Date: 04/01/2021
--
---------------------------------------------------------
---------------------------------------------------------
--
-- DESCRIPTION DU CODE :
-- ce fichier est l'architecture a2 du gnrateur de signaux de test
-- c'est une version condense de l'architecture a1
----------------------------------------------------------

architecture a1 of digital_gene is

subtype labtype is integer range 0 to nbsymbol ;		-- type de donnée correspondant aux labels
type labtab is array(0 to nbimag) of labtype ;			-- tableau des symboles à détecter
type imagtab is array(1 to nbimag,1 to lngimag+1) of unsigned(7 downto 0) ;	-- tableau d'images

function read_label(filname : string; numelem : integer) return labtab is
   variable content : labtab ; 
   variable fstatus :file_open_status;
   file fptr: text;
   variable file_line :line;
   
begin
    file_open(fstatus, fptr, filname, read_mode);
	readline(fptr, file_line);
	for i in integer range 1 to numelem loop
		read(file_line,content(i));
	end loop ;
	file_close(fptr);
    return content ;
end function ;

function read_images(filname : string; numimag : integer; numelem : integer) return imagtab is
   variable content : imagtab ; 
   variable fstatus :file_open_status;
   file fptr: text;
   variable file_line :line;
   variable pixel : integer range 0 to 255 ;
   
begin
    file_open(fstatus, fptr, filname, read_mode);
	for j in integer range 1 to numimag loop
		readline(fptr, file_line);
		for i in integer range 1 to numelem loop
			read(file_line,pixel);
			content(j,i) := to_unsigned(pixel,8) ;
		end loop ;
	end loop ;
	file_close(fptr);
    return content ;
end function ;


signal clki,clks,rst : std_logic := '0'  ;
constant labels : labtab := read_label("./tstlabels.txt",nbimag) ;
constant images : imagtab := read_images("./tstimgi.txt",nbimag,lngimag) ;

begin

rst <= '0', '1' after 10 ns ;			-- signal de reset
reset <= rst ;

pcki : process
begin
		clki <= '0'; 
		wait for clock_period;
		loop
			clki <= '1'; 
			wait for clock_period;
			clki <= '0'  ;	-- horloge interne
			wait for clock_period;
			while ready='0' loop
				wait for clock_period ;
			end loop ;
		end loop;
end process ;

-- clki <= not clki after clock_period/2 ;	-- horloge interne

clks <= not clks after clock_period/2 ;	-- horloge interne
clkimg <= clki ;							-- horloge en sortie
clock <= clks ;							-- horloge en sortie

gene : process(clki,rst)

variable numimage : integer := 0 ;
variable numpixel : integer := 0 ;
variable cptaux : integer := 0;
begin
  if (rst='0') then
	numimage := numimag ;
	numpixel := lngimag+1 ;
	start <= '0' ;
	cptaux := 101 ;
  elsif rising_edge(clki) then
	if (numpixel)>=lngimag then
	  if (cptaux>100) then
		if (numimage<nbimag) and (numpixel=lngimag) then
			numimage := numimage+1 ;
		end if ;
		numpixel := 1 ;
		start <= '1' after 10 ns;
	  else
		cptaux := cptaux + 1 ;
	  end if ;
	else
		start <= '0' after 10 ns;
		numpixel := numpixel+1 ;
		cptaux := 0 ;
    end if ;
  end if ;

  labl <= labels(numimage-1) after 10 ns ;
  image <= images(numimage,numpixel) after 10 ns ;
  nbimage <= numimage ;
end process ;

  
end architecture a1 ;

