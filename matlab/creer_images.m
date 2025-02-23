%-----------------------------------------------------------
% Ce programme est la propriete exclusive de CENTRALESUPELEC
% Tout  usage  non  authorise  ou reproduction de ce
% programme est strictement defendu. 
% Copyright (c) 2023 CENTRALESUPELEC Tous droits reserves
%-----------------------------------------------------------
%
% fichier : creer_images.m
% auteur  : P.BENABES  
% Copyright (c) 2023 SUPELEC
% Revision: 1.0  Date: 06/12/2023
%
%---------------------------------------------------
% DESCRIPTION DU MODULE :
% Ce programme a pour but de créer un jeu d'images contenant les 10
% chiffres afin de servir de base d'apprentissage d'un réseau de neurones.
% En partant d'un jeu d'images de référence contanant les 10 chiffres, 
% le programme va bouger les chiffres (translation), les agrandir ou les rapetisser, 
% et leur faire subir une rotation aléatoires, de manière à créer une très
% grosse base d'apprentissage
%---------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% parametres generaux
%
lrgch=160 ;     % taille des chiffres des images originales (ne pas toucher)
cote=28 ;       % taille des images du réseau de neurones (ne pas toucher)
nbimg=21000 ;  % nombre d'images pour l'apprentissage
nbtest=9000 ;  % nombre d'images de test

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% parametres de creation des images
%
nbficimagbmp = 4 ; % nombre de fichiers de fontes d'images différents 
facty = 0.8 ;  % facteur de taille en y (pour compenser la dilatation des images originales)
fscalmin = 0.8 ; % facteur d'échelle minimal
fscalmax = 1.0 ; % facteur d'échelle maximal
fang = 6; % écart type du facteur de rotation en °
fdltx = 8; % ecart type translation en x
fdlty = 8; % ecart type translation en y
modg = 3; % mode aléatoire sur chaque pixel :
% 0 on laisse tel quel 1 on passe en noir et blanc 
% 2 on met 15% de gain aléatoire sur la luminosite globale
% 3 on met 10% d'aléatoire sur chaque pixel

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ù
% lecture des fichiers d'images originales
% les tableaux chif contienne chaque chiffre individuel
%
for l=1:nbficimagbmp
    chiffres = imread(['chif' num2str(l) '.bmp']);
    chgr = im2gray(chiffres);
    chgr(:,end+1:10*lrgch)=255  ;
    for k=1:10
        chif{l,k}=255-chgr(:,1+(k-1)*lrgch:lrgch*k) ;
        %imshow(chif{k});
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% création des tableaux (vides) pour l'apprentissage
%
images=zeros(cote*cote,nbimg);
labels=zeros(10,nbimg);
tstimages=zeros(cote*cote,nbtest);
tstlabels=zeros(10,nbtest);

figure(1);
clf ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% création des images d'pprentissage par modification des images originales
%
for k=1:nbimg+nbtest
    if (mod(k,1000)==0) % un petit message toutes les 1000 images
        disp(k);
    end

    if (k<=nbficimagbmp*10)
        numimg= mod(k-1,10)+1  ;
        numfont=floor((k-1)/10 )+1 ;
    
        % on calcule les facteurs de modification
        %
        scale=0.75 ;      % echelle
        ang=0 ;            % angle de rotation
        dltx=0 ;           % deltax
        dlty=0 ;           % deltay
    else
        % on choisit de façon aléatoire l'image originale
        %
        numimg=floor(rand()*10 )+1 ;
        numfont=floor(rand()*nbficimagbmp )+1 ;
    
        % on calcule les facteurs de modification
        %
        scale=fscalmin+rand()*(fscalmax-fscalmin) ;      % echelle
        ang=fang*randn() ;             % angle de rotation
        dltx=randn()*fdltx ;           % deltax
        dlty=randn()*fdlty ;           % deltay
    end

    % dilatation de l'image
    %
    ch=imresize(chif{numfont,numimg},'scale',scale*[facty 1]) ;
    tailimx=size(ch,1);          % taille de l'image
    tailimy=size(ch,2);          % taille de l'image
    if (tailimx>lrgch)       % l'image a grandi
        dlx=floor((tailimx-lrgch)/2);  % ce qu'il faut supprimer à gauche
        ch(1:dlx,:)=[] ;
        ch=ch(1:lrgch,:);
    end
    if (tailimy>lrgch)       % l'image a grandi
        dly=floor((tailimy-lrgch)/2);  % ce qu'il faut supprimer en bas
        ch(:,1:dly)=[] ;
        ch=ch(:,1:lrgch);
    end
    if (tailimx<lrgch)   % l'image a diminué
        inx=floor((lrgch-tailimx)/2) ; % ce qu'il faut rajouter à gauche
        ch=[zeros(inx,tailimy) ; ch] ;
        ch (end+1:lrgch,:)=0 ;
    end 
    if (tailimy<lrgch)   % l'image a diminué
        iny=floor((lrgch-tailimy)/2) ; % ce qu'il faut rajouter à gauche
        ch=[zeros(lrgch,iny) , ch] ;
        ch (:,end+1:lrgch)=0 ;
    end 

    % rotation et translation de l'image
    %
    ch=imrotate(ch,ang,"crop");
    ch=imtranslate(ch,[dltx,dlty]);
    ch=imresize(ch,cote/160);

    % codage en niveaux de gris
    %
    if (modg==1)       % on code en noir et blanc
      ch=(ch>127)*255;
    elseif (modg==2)   % on met de l'aléatoire sur la luminosité globale
      ch=ch*(0.85 + rand*0.15);
    elseif (modg==3)   % on met de l'aléatoire sur chaque pixel
      ch=double(ch).*(0.9 + rand(cote)*0.1);
    end


    if (k<50)
     figure(1);
     imshow(ch);
     pause(0.1);
    end

    % à la fin on remplit les tableaux d'apprentissage ou de test
    %
    if (k<=nbimg)
        labels(numimg,k)=1 ;
        images(:,k)=reshape(ch',[1 cote*cote]);
    else
        tstlabels(numimg,k-nbimg)=1 ;
        tstimages(:,k-nbimg)=reshape(ch',[1 cote*cote]);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mise à l'échelle des pixels dans les images
%
tstlabels(:,1:40)=labels(:,1:40);
tstimages(:,1:40)=images(:,1:40);

images=images/255 ; 
imagesi = round(images*255) ; 
tstimages=tstimages/255 ;
tstimgi = round(tstimages*255) ;    % les images de test en entier 8 bits

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sauvegarde d'un fichier contenant les images de test
% pour le testbench
%
fid = fopen('tstimgi.txt', 'wt');
for k=1:size(tstimgi,2)
  fprintf(fid,'%d ',tstimgi(:,k));
  fprintf(fid,'\n');
end
fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% creation d'un fichier de 4096 pixels pour tester en dur
%
fid = fopen('geneimg.txt', 'wt');

% première image
cpt=1 ;
fprintf(fid,'constant imagdata1 : typmemimag := ( \n');
for k=1:cote   % pour chaque ligne
    for l=1 : 5 % pour chaque image
        for m=1 : cote % pour chaque pixel
            fprintf(fid,'%d, ',tstimgi((k-1)*cote+m,l*2));
            cpt=cpt+1 ;
        end
    fprintf(fid,'\n');
    end
end
for l=cpt:4095
            fprintf(fid,'%d, ',0);
end
fprintf(fid,'0 ) ; \n\n');

% deuxième image
cpt=1 ;
fprintf(fid,'constant imagdata2 : typmemimag := ( \n');
for k=1:cote   % pour chaque ligne
    for l=1 : 5 % pour chaque image
        for m=1 : cote % pour chaque pixel
            fprintf(fid,'%d, ',tstimgi((k-1)*cote+m,9+l*2));
            cpt=cpt+1 ;
        end
    fprintf(fid,'\n');
    end
end
for l=cpt:4095
            fprintf(fid,'%d, ',0);
end
fprintf(fid,'0 ) ; \n\n');

% troisième image
cpt=1 ;
fprintf(fid,'constant imagdata3 : typmemimag := ( \n');
for k=1:cote   % pour chaque ligne
    for l=1 : 5 % pour chaque image
        for m=1 : cote % pour chaque pixel
            fprintf(fid,'%d, ',tstimgi((k-1)*cote+m,40+l));
            cpt=cpt+1 ;
        end
    fprintf(fid,'\n');
    end
end
for l=cpt:4095
            fprintf(fid,'%d, ',0);
end
fprintf(fid,'0 ) ; \n\n');

% quatrième image
cpt=1 ;
fprintf(fid,'constant imagdata4 : typmemimag := ( \n');
for k=1:cote   % pour chaque ligne
    for l=1 : 5 % pour chaque image
        for m=1 : cote % pour chaque pixel
            fprintf(fid,'%d, ',tstimgi((k-1)*cote+m,45+l));
            cpt=cpt+1 ;
        end
    fprintf(fid,'\n');
    end
end
for l=cpt:4095
            fprintf(fid,'%d, ',0);
end
fprintf(fid,'0 ) ; \n\n');


fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sauvegarde d'un fichier contenant les labels des images de test
% pour le testbench
%

fid = fopen('tstlabels.txt', 'wt');
fprintf(fid,'%d ',(tstlabels'*[1 2 3 4 5 6 7 8 9 0]')');
fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% nettoyage des variables intermédiaires
%
clear ang ans ch chgr chif chiffres dltx dlty facty fid cpt
clear inx iny k lrgch scale tailimx tailimy numfont numimg modg
clear fang fdltx fdlty nbficimagbmp fscalmin fscalmax
save images.mat

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% création d'une grosse image à partir des images individuelles
% pour affichage de vérification
%
nbimgx=30 ; nbimgy=30 ;
biginm=zeros(nbimgx*cote,nbimgy*cote) ;
ind=1;
for k=1:nbimgx
    for l=1:nbimgy
        biginm(1+(k-1)*cote:k*cote,1+(l-1)*cote:l*cote)=reshape(images(:,ind),cote,cote)' ;
        ind=ind+1 ;
    end
end
imshow(biginm);

clear k l m ind nbimgx nbimgy cote biginm
