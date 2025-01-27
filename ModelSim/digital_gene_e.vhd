---------------------------------------------------------
-- Ce programme a ete dveloppe a CENTRALESUPELEC
-- Merci de conserver ce cartouche
-- Copyright  (c) 2022  CENTRALESUPELEC   
-- Dpartement Systmes lectroniques
-- ------------------------------------------------------
--
-- fichier : digital_gene_e.vhd
-- auteur  : P.BENABES   
-- Copyright (c) 2022 CENTRALESUPELEC
-- Revision: 1.0  Date: 08/09/2022
--
---------------------------------------------------------
---------------------------------------------------------
--
-- DESCRIPTION DU CODE :
-- ce fichier est le generateur de signaux de test
-- pour tester le reseau de neurones
-- il charge le fichier d'images puis il les transmet en série
--
----------------------------------------------------------

LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

ENTITY digital_gene IS
	GENERIC (    nbimag : integer := 100;       -- nombre d'images dans le fichier de test
				 numimag : integer := 1;        -- numéro de la première image envoyée dans le test
				 lngimag : integer := 784;		-- longueur d'une image 
				 nbsymbol : integer := 10;		-- nombre de symboles à détecter
				 clock_period : time := 2 ns  -- periode d'horloge
    ) ;    
    PORT(
        ready      : IN std_logic;				-- reset de la logique
        reset      : OUT std_logic;				-- reset de la logique
        clock      : OUT std_logic;				-- horloge systeme
        start	   : OUT std_logic;				-- demarrage de l'image
        clkimg     : OUT std_logic;				-- horloge image
		image      : OUT unsigned(7 downto 0);  -- contenu des pixels
		nbimage    : OUT integer;   			-- numero de l'image
		labl	   : OUT integer range 0 to nbsymbol   -- symbole attendu
    );
END digital_gene;
