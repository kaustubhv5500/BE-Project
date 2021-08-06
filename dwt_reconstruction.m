clc;
clear;
close;

% Using DWT Filter bank to perform dwt and perform reconstruction
fb = dwtfilterbank();

Hd = [0 -1 5 12 5 -1 0 0]/20*sqrt(2);
Gd = [0 3 -15 -73 170 -73 -15 3]/280*sqrt(2);
Hr = [0 -3 -15 73 170 73 -15 -3]/280*sqrt(2);
Gr = [0 -1 -5 12 -5 -1 0 0]/20*sqrt(2);

fbAna = dwtfilterbank('Wavelet','Custom',...
    'CustomScalingFilter',[Hd Hr],'CustomWaveletFilter',[Gd Gr]);
fbSyn = dwtfilterbank('Wavelet','Custom',...
    'CustomScalingFilter',[Hd Hr],'CustomWaveletFilter',[Gd Gr],...
    'FilterType','Synthesis');

freqz(fb);
figure;
Fs = 1e3;
t = 0:1/Fs:1-1/Fs;
x = cos(2*pi*64*t).*(t>=0.1 & t<0.3)+sin(2*pi*16*t).*(t>=0.5 & t<0.9);
y = sin(2*pi*10*t).*(t>=0.4 & t<0.9)+square(2*pi*10*t).*(t>=0.8 & t<0.6);

[Lo, Hi] = filters(fb);
Lo = Lo(:,1);
Hi = Hi(:,1);

[LoAna, HiAna] = filters(fbAna);
[LoSyn, HiSyn] = filters(fbSyn);

LoAna = LoAna(:,1);
HiAna = HiAna(:,1);
LoSyn = LoSyn(:,1);
HiSyn = HiSyn(:,1);

[cA_Ana, cD_Ana] = dwt(y,LoAna,HiAna);
[cA, cD] = dwt(x, Lo,Hi);
sum = cA_Ana(1:length(cA)) + cA;
plot(sum);
grid on;
title('Plot of Summed Signal');
figure;

x_ = idwt(cA,cD,Lo,Hi);
y_ = idwt(sum,[],LoSyn,HiSyn);
xy = idwt(sum,[],Lo,Hi);

plot(t,x,t,x_);
grid on;
legend('Original','Reconstructed');
title('Plot of reconstructed signal using DWT');
figure;

y_ = [y_,zeros(1,length(y)-length(y_))];
plot(t,y,t,y_);
grid on;
legend('Original Y','Reconstructed Y');
title('Plot of Reconstructed Y after Summing and Filtering');
figure;

plot(t,x,t,xy);
grid on;
legend('Original X','Reconstructed X');
title('Plot of Reconstructed X after Summing and Filtering');
