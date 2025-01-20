function a = apply(n,param)
%TANSIG.APPLY Apply transfer function to inputs

global tansigparam
% Copyright 2012-2015 The MathWorks, Inc.

%  disp('my tansig');

  if (tansigparam==0)                     % la sigmoide originale 
    a = 2 ./ (1 + exp(-2*n)) - 1;
  elseif (tansigparam==1)                 % lineaire par morceau
      x=0 : 3 ;
      y=2 ./ (1 + exp(-2*x)) - 1;
      x=[x x(end)+1];
      y=[y y(end)];
      a=interp1(x,y,abs(n),'linear','extrap') ;
      a=a.*sign(n) ;
  elseif (tansigparam==2)                 % identité puis saturation
      x=[0 1];
      y=[0 1];
      x=[x x(end)+1];
      y=[y y(end)];
      a=interp1(x,y,abs(n),'linear','extrap') ;
      a=a.*sign(n) ;
  elseif (tansigparam==3)                 % identité puis saturation
      x=[0 2];
      y=[0 1];
      x=[x x(end)+1];
      y=[y y(end)];
      a=interp1(x,y,abs(n),'linear','extrap') ;
      a=a.*sign(n) ;
  elseif (tansigparam==4)                 % identité pour les nombres positifs
      a=n.*(n>=0) ;
  elseif (tansigparam==5)                 % chapeau pointu
      a=(1-n).*(n>=0).*(n<=1)+ (1+n).*(n>=-1).*(n<0)  ;
  end

end


  