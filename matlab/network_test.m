if ~exist('net','var')
    load ('reseaucomplet.mat');
end

Numimage=1;

imag=tstimages(:,Numimage);
    
for k=1:size(cfq,2)

    n_sum1(:,k) = cfq(:,1:k)*ccf*imag(1:k,1) ;

end
n_sum = n_sum1(:,k) + ctq*cct ;

for k=1:size(n_sum)
    
    if (n_sum(k,1)>2)
        activout(k,1) = 1;
    elseif (n_sum(k,1)<-2)
        activout(k,1) = -1;
    else
        activout(k,1) = n_sum(k,1)/2.0;
    end

end

for k=1:size(cf2q,2)

    n_sum2(:,k) = cf2q(:,1:k)*ccf2*activout(1:k,1) ;

end
n_sum_final = n_sum2(:,k) + ct2q*cct2 ;

    
figure(1);
subplot(3,1,1);
plot(n_sum1');
subplot(3,1,2)
plot(n_sum1(1,:));
subplot(3,1,3);
plot(n_sum,'*');

figure(2);
subplot(3,1,1);
plot(n_sum2');
subplot(3,1,2)
plot(n_sum2(1,:));
subplot(3,1,3);
plot(n_sum_final,'*');