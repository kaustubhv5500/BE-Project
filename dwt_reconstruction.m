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
x = sin(2*pi*12*t).*(t<=0.45);
y = square(2*pi*12*t).*(t>=0.5);
Tx = [x,y];
% x = cos(2*pi*64*t).*(t>=0.1 & t<0.3)+sin(2*pi*16*t).*(t>=0.5 & t<0.9);
% y = sin(2*pi*12*t) + cos(2*pi*12*t);
% y = sin(2*pi*10*t).*(t>=0.4 & t<0.9)+square(2*pi*10*t).*(t>=0.8 & t<0.6);

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
[A, D] = dwt(Tx,LoSyn,HiSyn);
[cA, cD] = dwt(x, Lo,Hi);
sum = [cA_Ana, cA];
% sum = cA_Ana(1:length(cA)) + cA;
plot(sum);
grid on;
title('Plot of Summed Signal');
figure;

x_ = idwt(cA,cD,Lo,Hi);
y_ = idwt(sum,[],LoAna,HiAna);
% xy = idwt(sum,[],Lo,Hi);
xy = y_(1001:2000);
y_ = y_(1:1000);
Rx = idwt(A,[],LoAna,HiAna);

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

% Using Dyadic analysis and synthesis filter banks objects for
% reconstruction based on given example coefficients
% 'NumLevels' parameter can be changed to increase the number of levels  
% dyadic DWT is performed
% TODO: Create novel algorithm to design a custom highpass and lowpass filters to
% ensure perfect reconstruction at the gievn frequency range for satellite
% communications
% Frequency specifications for audio signals: 3.4-4 kHz

load dspwlets;    % load filter coefficients and time and frequency parameters
dyadicAnalysis = dsp.DyadicAnalysisFilterBank( ...
    'CustomLowpassFilter', lod, ...
    'CustomHighpassFilter', hid, ...
    'NumLevels', 4 );

dyadicSynthesis = dsp.DyadicSynthesisFilterBank( ...
    'CustomLowpassFilter',[0 lor], ...
    'CustomHighpassFilter',[0 hir], ...
    'NumLevels', 4 );

scope1 = dsp.TimeScope(2, ...
  'Name', 'Original Signal', ...
  'SampleRate', fs, ...
  'TimeSpan', 20, ...
  'YLimits', [-2 2], ...
  'ShowLegend', true, ...
  'TimeSpanOverrunAction', 'Scroll');

scope2 = dsp.TimeScope(2, ...
  'Name', 'Reconstructed Signal', ...
  'SampleRate', fs, ...
  'TimeSpan', 20, ...
  'YLimits', [-2 2], ...
  'ShowLegend', true, ...
  'TimeSpanOverrunAction', 'Scroll');

scope3 = dsp.TimeScope(2, ...
  'Name', 'Error in Reconstructed and Original Signal', ...
  'SampleRate', fs, ...
  'TimeSpan', 20, ...
  'YLimits', [-0.05 0.05], ...
  'ShowLegend', true, ...
  'TimeSpanOverrunAction', 'Scroll');

x = [x, zeros(1,2^10 - length(x))];
y = [y,zeros(1,2^10 - length(y))];
signal = reshape(x,length(x),1) + reshape(y,length(y),1);
Tx = dyadicSynthesis(signal);
figure;
plot(Tx);
title('Transmitted Signal');
grid on;

Rx_ = dyadicAnalysis(Tx);
error = Rx_ - signal;
figure;
plot(signal);
hold on;
plot(Rx_);
grid on;
hold off;
title('Plot of Original and Reconstructed Signals');
legend('Original','Reconstructed');

release(dyadicAnalysis);
release(dyadicSynthesis);

t = 0.1:0.1:25.6;
x = sin(t + pi);
y = square(t);
error_rate = 0;

Num = 15;
for i=1:Num
    Tx = [x y];
    Tx = reshape(Tx,length(Tx),1);
    Tx_dwt = dyadicSynthesis(Tx);
    Rx = dyadicAnalysis(Tx_dwt);
    scope1(Tx(1:256),Tx(256:512));
    scope2(Rx(1:256),Rx(256:512));
    error1 = (Rx(1:256) - Tx(1:256))/length(Rx(1:256));
    error2 = (Rx(256:512) - Tx(256:512))/length(Rx(256:512));
    scope3(error1,error2);
    error_rate = error_rate + (abs(mean(error1)/mean(Tx(1:256))) + abs(mean(error2)/mean(Tx(256:512))))/2;
end

error_rate = error_rate/Num;
fprintf('Mean Error Rate of the system: %f\n',error_rate/Num);
release(dyadicAnalysis);
release(dyadicSynthesis);
release(scope1);
release(scope2);
release(scope3);
close all;


