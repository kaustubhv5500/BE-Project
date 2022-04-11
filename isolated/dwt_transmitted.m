% Final Year Project: To implement a Wavelet Transform based PR Transmultiplexer for
% satellite communications
% Authors: Kaustubh V, Gokul Nair, Arseta Singh
% Department of Electronics and Telecommunication Engineering 
% Sardar Patel institute of Technology, Mumbai
% MATLAB Version: R2018a

clc;
clear;
close all;

% Using DWT Filter bank to perform dwt and perform reconstruction
fb = dwtfilterbank('Wavelet','sym6');

Hd = [0 -1 5 12 5 -1 0 0] / 20 * sqrt(2);
Gd = [0 3 -15 -73 170 -73 -15 3] / 280 * sqrt(2);
Hr = [0 -3 -15 73 170 73 -15 -3] / 280 * sqrt(2);
Gr = [0 -1 -5 12 -5 -1 0 0] / 20 * sqrt(2);

fbAna = dwtfilterbank('Wavelet','Custom',...
    'CustomScalingFilter',[Hd Hr],'CustomWaveletFilter',[Gd Gr]);
fbSyn = dwtfilterbank('Wavelet','Custom',...
    'CustomScalingFilter',[Hd Hr],'CustomWaveletFilter',[Gd Gr],...
    'FilterType','Synthesis');

Fs = 1e3;
t = 0:1/Fs:1-1/Fs;
x = sin(2*pi*12*t);
y = square(2*pi*12*t);

scope1 = dsp.TimeScope(1, ...
  'Name', 'Original Signal', ...
  'SampleRate', Fs, ...
  'TimeSpan', 20, ...
  'YLimits', [-2 2], ...
  'ShowLegend', true, ...
  'TimeSpanOverrunAction', 'Scroll');

scope2 = dsp.TimeScope(1, ...
  'Name', 'Reconstructed Signal', ...
  'SampleRate', Fs, ...
  'TimeSpan', 20, ...
  'YLimits', [-2 2], ...
  'ShowLegend', true, ...
  'TimeSpanOverrunAction', 'Scroll');

scope3 = dsp.TimeScope(1, ...
  'Name', 'Transmitted Signal', ...
  'SampleRate', Fs, ...
  'TimeSpan', 20, ...
  'YLimits', [-2 2], ...
  'ShowLegend', true, ...
  'TimeSpanOverrunAction', 'Scroll');

[Lo, Hi] = filters(fb);
Lo = Lo(:,1);
Hi = Hi(:,1);

[LoAna, HiAna] = filters(fbAna);
[LoSyn, HiSyn] = filters(fbSyn);

LoAna = LoAna(:,1);
HiAna = HiAna(:,1);
LoSyn = LoSyn(:,1);
HiSyn = HiSyn(:,1);

[cA_Ana, cD_Ana] = dwt(y,LoSyn,HiSyn);
[cA, cD] = dwt(x, Lo,Hi);
sum = [cA_Ana, cA];

x_ = idwt(cA,cD,Lo,Hi);
y_ = idwt(sum,[],LoAna,HiAna);
xy = y_(1001:2000);
y_ = y_(1:1000);

Num = 50;
nsignals = 3;

Tx = x;
[A, D] = dwt(Tx,LoSyn,HiSyn);
Rx = idwt(A,[],LoAna,HiAna);

plot(Tx);
grid on;
title('Input Signal');

figure;
plot(Rx);
grid on;
title('De-multiplexed Signal');

figure;
plot(A);
grid on;
title('Transmitted Signal');


