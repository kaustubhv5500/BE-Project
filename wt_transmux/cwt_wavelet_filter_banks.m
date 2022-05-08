% CWT using designed wavelet filter bank
clear;
clc;
close;

fb = cwtfilterbank;
freqz(fb)
Fs = 1e3;
t = 0:1/Fs:1-1/Fs;
x = cos(2*pi*64*t).*(t>=0.1 & t<0.3)+sin(2*pi*16*t).*(t>=0.5 & t<0.9);
y = sawtooth(2*pi*12*t).*(t>= 0.5);
figure;
plot(t,x,t,y);
title('Signal');
legend('x','y');
figure;

fb = cwtfilterbank('SignalLength',numel(t),'SamplingFrequency',Fs,'FrequencyLimits',[1 500]);
freqz(fb)
title('Frequency Responses — Morse (3,60) Wavelet')
fb3x5 = cwtfilterbank('SignalLength',numel(t),'SamplingFrequency',Fs,'TimeBandwidth',5);
figure
freqz(fb3x5)
title('Frequency Responses — Morse (3,5) Wavelet')
figure
cwt(x,'FilterBank',fb) % Use the designed fb wavelet filter to perform cwt
title('Magnitude Scalogram — Morse (3,60)')
figure
cwt(x,'FilterBank',fb3x5)
title('Magnitude Scalogram — Morse (3,5)');

wt = cwt(x,'FilterBank',fb);
iwt = icwt(wt,fb);
plot(x);
hold on;
plot(iwt);
grid on;
legend('Original Signal','Reconstructed');                 