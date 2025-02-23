%-----------------------------------------------------------
% Ce programme est la propriete exclusive de CENTRALESUPELEC
% Tout  usage  non  authorise  ou reproduction de ce
% programme est strictement defendu. 
% Copyright (c) 2023 CENTRALESUPELEC Tous droits reserves
%-----------------------------------------------------------
%
% fichier : neurone_complet.m
% auteur  : P.BENABES  
% Copyright (c) 2023 SUPELEC
% Revision: 1.0  Date: 06/12/2023
%
%---------------------------------------------------
% DESCRIPTION DU MODULE :
% Ce programme a pour but de dimensionner un réseau de neurones à 2 étages
% Il utilise le jeu d'images fourni par MINST ou les images créées par
% l'utilisateur
%---------------------------------------------------

global tansigparam

%% nombre de neurones dans la première couche du réseau
hiddenLayerSize = 80;
% nombre de bits pour quantifier la partie décimale des coefficients
nbitq=32;

%% Les paramètres du réseau à déterminer
tansigfn=2 ;    % la fonction d'activation choisie dans le reseau final
versimpl=1 ;    % 0 = version complete du réseau de neurones ; (avec optimisation des pixels utilisés)
                % 1 = version simplifiée (sans optimisation des pixels utilisés)

%% nombre d'images testées à la main
ntst=1000 ;


%% On plote la fonction d'activation des neurones choisie

tansigparam=tansigfn ;
figure(1); clf 
xt=-5:0.1:5 ;
plot(xt,mytansig(xt),'r');
grid on ; hold on ;
plot(xt,tansig(xt),'b');
title ("fonction de decision du réseau (apprentissage et final)")
pause(0.1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% si aucun jeu d'image est chargé
% On charge les fichiers contenant les images pour l'apprentissage et le test
% fournis avec la fonction MNIST
%
if ~exist("images","var")
    images = loadMNISTImages('train-images.idx3-ubyte');
    labels = loadMNISTLabels('train-labels.idx1-ubyte');
    tstimages = loadMNISTImages('t10k-images.idx3-ubyte');
    tstlabels = loadMNISTLabels('t10k-labels.idx1-ubyte');
    labels = labels';

    tstimgi = round(tstimages*255) ;    % les images de test en entier 8 bits

    fid = fopen('tstimgi.txt', 'wt');
    for k=1:size(tstimgi,2)
      fprintf(fid,'%d ',tstimgi(:,k));
      fprintf(fid,'\n');
    end
    fclose(fid);

    fid = fopen('tstlabels.txt', 'wt');
    fprintf(fid,'%d ',tstlabels);
    fclose(fid);

    % dummyvar function doesnt take zeroes
    labels(labels==0)=10;
    labels=dummyvar(labels)'; %
    tstlabels = tstlabels';
    tstlabels(tstlabels==0)=10;
    tstlabels=dummyvar(tstlabels)';

end

% fonction utilisée pour l'apprentissage
trainFcn = 'trainscg';

%% calcul du réseau

%if ~exist("net","var") || (hiddenLayerSize~=net.layers{1}.size)
    net = patternnet(hiddenLayerSize, trainFcn);
    
    % Setup Division of Data for Training, Validation, Testing
    % For a list of all data division functions type: help nndivide
    % net.divideFcn = 'dividerand'; % Divide data randomly
    % net.divideMode = 'sample'; % Divide up every sample
    net.divideParam.trainRatio = 80/100;
    net.divideParam.valRatio = 20/100;
    net.divideParam.testRatio = 0/100;
    % Choose a Performance Function
    % For a list of all performance functions type: help nnperformance
    % Cross-Entropy
    net.performFcn = 'crossentropy';
    % Choose Plot Functions
    % For a list of all plot functions type: help nnplot
    net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
    'plotconfusion', 'plotroc'};
    
    net.layers{1}.transferFcn='tansig' ;
    %net.layers{1}.transferFcn='mytansig' ;
    
    % Création du réseau par apprentissage sur les images
    [net,tr] = train(net,images,labels);

    % On teste maintenant le réseau avec l'ensemble des images 
    y = net(images);
    performance_netdata = perform(net,labels,y);
    tind = vec2ind(labels);
    yind = vec2ind(y);
    percentErrors_netdata = sum(tind ~= yind)/numel(tind)*100 ;
    disp(['pourcentage d''erreurs après entrainement : ' num2str(percentErrors_netdata) '%']);

%end

% on nécupère les coefficients du réseau
% cf = coefficients du premier étage
% ct = terme constant du premier étage
% cf2 = coefficients du deuxième étage
% ct2 = termes constants du deuxième étage
coef=net.IW(1) ;
cf=coef{1} ;
coef=net.LW(2) ;
cf2=coef{1} ;
coef=net.b(1) ;
ct=coef{1} ;
coef=net.b(2) ;
ct2=coef{1} ;
% range contient les pixels utilisés 
range = net.inputs{1}.range(:,2) ;  % les pixels utilisés
rangq = (range>0) ;


%% On quantifie maintenant les coefficients du réseau et on les réinjecte dans le réseua

cfq=round(cf*(2^(nbitq)))/2^(nbitq) ;
coef=net.IW(1) ;
coef{1}=cfq ;
net.IW(1)=coef ;

cf2q=round(cf2*(2^nbitq))/2^nbitq ;
coef=net.LW(2) ;
coef{1}=cf2q ;
net.LW(2)=coef ;

ctq=round(ct*(2^(nbitq)))/2^(nbitq) ;
coef=net.b(1) ;
coef{1}=ctq ;
net.b(1)=coef ;

ct2q=round(ct2*(2^nbitq))/2^nbitq ;
coef=net.b(2) ;
coef{1}=ct2q ;
net.b(2)=coef ;

% en version simplifiée on remplit les coefficients inutilisés par des '0'
if (versimpl==1)
  ind = find(rangq==1) ;
  tmp=zeros(hiddenLayerSize,length(rangq));
  tmp(:,ind)=cf ;
  cf=tmp ;
  tmp(:,ind)=cfq ;
  cfq=tmp ;
  range=ones(size(range)) ;
  rangq=ones(size(rangq)) ; 
end

% normalisation des coefficients par rapport aux images
% on fait cf*2 et ct=ct-som(cf) 
% puis on calcule la valeur maximale et on fait une remise à l'échelle
ccf = 2^-floor(-(log(max(max(abs(cf*2))))/log(2)));
ccf2 = 2^-floor(-(log(max(max(abs(cf2))))/log(2)));
cct = 2^-floor(-(log(max(max(abs(ct-cf*ones(size(cf,2),1)))))/log(2)));
cct2 =  2^-floor(-(log(max(max(abs(ct2))))/log(2)));

disp(['coefficients de normalisation : ' num2str(ccf) ' '  num2str(ccf2) ' ' num2str(cct) ' ' num2str(cct2)]);
cfq=round(cf*2/ccf*(2^nbitq))/2^nbitq ;
cf2q=round(cf2/ccf2*(2^nbitq))/2^nbitq ;
ctq=round((ct-cf*ones(size(cf,2),1))/cct*(2^nbitq))/2^nbitq ;
ct2q=round(ct2/cct2*(2^nbitq))/2^nbitq ;

% on verifie qu'on ne depasse pas 1
disp(['max des coeff cfq cf2q ctq ct2q : ' num2str(max(max(abs(cfq)))) ' ' num2str(max(max(abs(cf2q)))) ' ' num2str(max(max(abs(ctq)))) ' ' num2str(max(max(abs(ct2q))))])

%% création des fichiers contenant les coefficients du réseau

% les fichiers coef1 contiennent les coefficients de la première couche
% on cree un fichier de coefficients brut et un fichier vhdl

fid = fopen('coef1.txt', 'wt');
fid2 = fopen('coef1.vhd', 'wt');    % contient les coefficients du premier étage
fid3 = fopen('coef1f.vhd', 'wt');   % contient les coefficients du premier etage dans un tableau de taille une puissance de 2
fprintf(fid2,"%s",'constant coef1 : typtabcnf1 := ( ');
fprintf(fid3,"%s",'constant coef1 : typtabcnf1b := ( ');
for k=1:size(cfq,2)
  fprintf(fid,'%d ',cfq(:,k)*2^nbitq);
  fprintf(fid,'\n');

  fprintf(fid2,"%s",'( ');
  fprintf(fid3,"%s",'( ');
  for l=1:size(cfq,1)-1
    fprintf(fid2,'to_sfixed(%d.0/%d.0,1,-nbitq), \n', cfq(l,k)*2^nbitq,2^nbitq);
    fprintf(fid3,'to_sfixed(%d.0/%d.0,1,-nbitq), \n', cfq(l,k)*2^nbitq,2^nbitq);
  end
  fprintf(fid2,'to_sfixed(%d.0/%d.0,1,-nbitq) ', cfq(end,k)*2^nbitq,2^nbitq);
  fprintf(fid3,'to_sfixed(%d.0/%d.0,1,-nbitq) ', cfq(end,k)*2^nbitq,2^nbitq);
  if (k==size(cfq,2))
    fprintf(fid2,' ) \n');
    fprintf(fid3,' ), \n');
  else
    fprintf(fid2,' ), \n');
    fprintf(fid3,' ), \n');
  end
end

% pour le 2è fichier on remplit de zeros jusqu'à 1024
for k=size(cfq,2)+1:1024
  fprintf(fid3,"%s",'( ');
  for l=1:size(cfq,1)-1
    fprintf(fid3,'to_sfixed(0.0/%d.0,1,-nbitq), \n', 2^nbitq);
  end
  fprintf(fid3,'to_sfixed(0.0/%d.0,1,-nbitq) ', 2^nbitq);
  if (k==1024)
    fprintf(fid3,' ) \n');
  else
    fprintf(fid3,' ), \n');
  end
end

fprintf(fid2,"%s",' ) ;');
fprintf(fid3,"%s",' ) ;');
fclose(fid);
fclose(fid2);
fclose(fid3);


% les coefficients cst contiennent les constantes de le première couche
% on cree un fichier de coefficients brut et un fichier vhdl

fid = fopen('cst1.txt', 'wt');
fid2 = fopen('cst1.vhd', 'wt');
fprintf(fid,' %d',ctq*2^nbitq);

fprintf(fid2,"%s",'constant cst1 : typtabcs1 := ( ');
for l=1:length(ctq)-1
  fprintf(fid2,'to_sfixed(%d.0/%d.0,1,-nbitq), ', ctq(l)*2^nbitq,2^nbitq);
end
fprintf(fid2,'to_sfixed(%d.0/%d.0,1,-nbitq) ', ctq(end)*2^nbitq,2^nbitq);
fprintf(fid2,"%s",' ) ;');
fclose(fid);
fclose(fid2);

% les coefficients coef2 contiennent les coefficients de la 2è couche
% on cree un fichier de coefficients brut et un fichier vhdl

fid = fopen('coef2.txt', 'wt');
fid2 = fopen('coef2.vhd', 'wt');
fprintf(fid2,"%s",'constant coef2 : typtabcnf2 := ( ');
for k=1:size(cf2q,2)
  fprintf(fid,'%d ',cf2q(:,k)*2^nbitq);
  fprintf(fid,'\n');
  fprintf(fid2,"%s",'( ');
  for l=1:size(cf2q,1)-1
    fprintf(fid2,'to_sfixed(%d.0/%d.0,1,-nbitq), \n', cf2q(l,k)*2^nbitq,2^nbitq);
  end
  fprintf(fid2,'to_sfixed(%d.0/%d.0,1,-nbitq) ', cf2q(end,k)*2^nbitq,2^nbitq);
  if (k==size(cf2q,2))
    fprintf(fid2,' ) \n');
  else
    fprintf(fid2,' ), \n');
  end
end
fprintf(fid2,"%s",' ) ;');
fclose(fid);
fclose(fid2);

% les coefficients cst2 contiennent les constantes de la 2è couche
% on cree un fichier de coefficients brut et un fichier vhdl

fid = fopen('cst2.txt', 'wt');
fid2 = fopen('cst2.vhd', 'wt');
fprintf(fid,' %d',ct2q*2^nbitq);
fprintf(fid2,"%s",'constant cst2 : typtabcs2 := ( ');
for l=1:length(ct2q)-1
  fprintf(fid2,'to_sfixed(%d.0/%d.0,1,-nbitq), ', ct2q(l)*2^nbitq,2^nbitq);
end
fprintf(fid2,'to_sfixed(%d.0/%d.0,1,-nbitq) ', ct2q(end)*2^nbitq,2^nbitq);
fprintf(fid2,"%s",' ) ;');
fclose(fid);
fclose(fid2);

% on cree un fichier de coefficients brut et l

disp(['nombre pixels utilisés : ' num2str(sum(rangq))]);
% fichier indiquant quels pixels sont utilises
fid = fopen('range.txt', 'wt');
fprintf(fid,'%d ',rangq);
fclose(fid);

% on remplit le fichier vhdl avec les constantes

fidtv = fopen('coeft.vhd', 'wt');

fprintf(fidtv,"constant lngimag : integer := %d ; \n",size(images,1));
fprintf(fidtv,"constant lngfilt : integer := %d ; \n",sum(rangq));
fprintf(fidtv,"constant nbneuron : integer := %d ; \n",hiddenLayerSize);
fprintf(fidtv,"constant nbsymbol : integer := 10 ; \n");
fprintf(fidtv,"constant nbitq : integer := %d ; \n\n\n",nbitq);

fprintf(fidtv,"constant ccf : integer := %d ; \n",ccf);
fprintf(fidtv,"constant ccf2 : integer := %d ; \n",ccf2);
fprintf(fidtv,"constant cct : integer := %d ; \n",cct);
fprintf(fidtv,"constant cct2 : integer := %d ; \n\n",cct2);

fprintf(fidtv,"%s",'constant usedpix : typtabup := ( ');
fprintf(fidtv,"'%d', ",rangq(1:end-1));
fprintf(fidtv,"'%d' ",rangq(end));
fprintf(fidtv,"%s \n\n",' ) ;');




%% les coefficients coeft contiennent l'ensemble des coefficient
% on cree un fichier de coefficients brut et un fichier vhdl

%% on calcule le nombre total de coefficients
tailtotale = numel((cfq)) + numel((ctq)) + numel((cf2q)) + numel((ct2q)) ;

file1siz = 2^floor((log(tailtotale)/log(2)));
file2siz = 2^-floor(-(log(tailtotale-file1siz)/log(2)));

disp (['taille mémoire 1 : ' num2str(file1siz) ' taille mémoire 2 : ' num2str(file2siz)]);

fidt = fopen('coeft.txt', 'wt');
ipix=0 ;

% ecriture des coefficients de la première couche 

fprintf(fidtv,"%s",'constant allcoef1 : typtabcst := ( ');
for k=1:size(cfq,2)
  for l=1:size(cfq,1)
    fprintf(fidt,' %d',cfq(l,k)*2^nbitq);
    [ipix,fidt]=incripix(ipix,fidt,fidtv,file1siz,cfq(l,k)*2^nbitq,nbitq);
  end
  fprintf(fidt,'\n');
end

% ecriture des constantes de la première couche

fprintf(fidt,' %d',ctq*2^nbitq); fprintf(fidt,'\n');
for l=1:length(ctq)
  [ipix,fidt]=incripix(ipix,fidt,fidtv,file1siz,ctq(l)*2^nbitq,nbitq);
end

% ecriture des coefficients de la deuxième couche 

for k=1:size(cf2q,2)
  fprintf(fidt,' %d',cf2q(:,k)*2^nbitq);  fprintf(fidt,'\n');
  for l=1:size(cf2q,1)
    [ipix,fidt]=incripix(ipix,fidt,fidtv,file1siz,cf2q(l,k)*2^nbitq,nbitq);
  end
end

% ecriture des constantes de la deuxième couche

fprintf(fidt,' %d',ct2q*2^nbitq); fprintf(fidt,'\n');
for l=1:length(ct2q)
  [ipix,fidt]=incripix(ipix,fidt,fidtv,file1siz,ct2q(l)*2^nbitq,nbitq);
end

% fin du remplissage du fichier total
fclose(fidt);
disp(['taille du fichier : ' num2str(ipix)]);
if (ipix<file1siz)
    while ipix<file1siz-1 
      fprintf(fidtv,'to_sfixed(0.0,1,-nbitq), \n');
      ipix=ipix+1 ;
    end
    fprintf(fidtv,'to_sfixed(0.0,1,-nbitq) \n');
    ipix=ipix+1 ;
else
    while ipix<file1siz+file2siz-1 
      fprintf(fidtv,'to_sfixed(0.0,1,-nbitq), \n');
      ipix=ipix+1 ;
    end
    fprintf(fidtv,'to_sfixed(0.0,1,-nbitq) \n');
    ipix=ipix+1 ;

end
fprintf(fidtv,"%s",' ) ;');
fclose(fidtv);

range=reshape(rangq,28,28);

%%

figure(2) ; mesh(range) ;
title("pixels utilisés")

% affichage du réseau sous forme d'image de convolution
idim = find(rangq==1) ;
figure(3) ; clf
cfs=cf2(5,:) ; % coefficient pour détecter le 3
sg=sign(cfs) ;
cfs=abs(cfs) ;
[st,st2]=sort(cfs,'descend');

nimg=-floor(-sqrt(hiddenLayerSize));
for k=1:hiddenLayerSize
    cfi=cf(st2(k),:);
    imc=zeros(1,28*28);
    imc(idim)=cfi;
    imc=reshape(imc,28,28);
    imc=imc*sg(st2(k)) ;
    imc=imc-min(min(imc)) ;
    imc=imc/max(max(imc)) ;
    subplot(nimg,nimg,k);
    image(imc/max(max(imc))*256);
end


%% On teste le réseau avec les images de test
tsty = net(tstimages);
performance_testdata = perform(net,tstlabels,tsty);
tind = vec2ind(tstlabels);
yind = vec2ind(tsty);
percentErrors_testdata = sum(tind ~= yind)/numel(tind)*100 ;
disp (['erreurs reseau ' num2str(percentErrors_testdata) ' %']);
%% on teste le réseau 'a la main'

ncoefused=sum(rangq) ;               % nombre de coef utilisés
ind=find(range>0) ;                 % indice des pixels utilisés

lab_val=zeros(1,ntst);
lab_orig=zeros(1,ntst);

mx=zeros(1,ntst);
for Numimage=1:ntst
    imag=tstimages(:,Numimage) ;
    
    tstz = net(imag) ;
    
    imag=imag(ind); %./range ;
    
    % imag=mapminmax(imag',-1,1)' ;  % on remplace le mapin par un *2-1 sur les pixels
    % ce qui revient à changer les coefficients et le terme constant
    
    
    % calcul du reseau première couche
    n_sum = cfq*ccf*imag + ctq*cct ;
    n_out = mytansig(n_sum) ;
    
    % calcul du réseau 2è couche
    n2_sum = cf2q*ccf2*n_out+ct2q*cct2 ;
    mx(Numimage)=max(n2_sum) ;
    n2_out = softmax(n2_sum) ;
    
    lab_val(Numimage) = find(n2_out==max(n2_out));
    lab_orig(Numimage)= find(tstlabels(:,Numimage)==max(tstlabels(:,Numimage)));

end

disp (['erreurs à la main ' num2str((1-mean(lab_val==lab_orig))*100) ' %']);

save reseaucomplet.mat
