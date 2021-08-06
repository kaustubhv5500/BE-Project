clc;
clear;
close;

% Using DWT Filter bank to perform dwt and perform reconstruction
fb = dwtfilterbank();
freqz(fb)
Fs = 1e3;
t = 0:1/Fs:1-1/Fs;
x = cos(2*pi*64*t).*(t>=0.1 & t<0.3)+sin(2*pi*16*t).*(t>=0.5 & t<0.9);

[Lo, Hi] = filters(fb);
Lo = Lo(:,1);
Hi = Hi(:,1);

[cA, cD] = dwt(x, Lo,Hi);
x_ = idwt(cA,cD,Lo,Hi);

plot(t,x,t,x_);
grid on;
legend('Original','Reconstructed');
title('Plot of reconstructed signal using DWT');
