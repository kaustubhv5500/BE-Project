clc;
clear;
close;

fs = 100;
sine = dsp.SineWave('Frequency',fs/68, 'SampleRate',fs, 'SamplesPerFrame', fs*2);

scope1 = dsp.TimeScope('Name','Input Sine Wave','TimeSpan',8,'SampleRate',fs,'ShowLegend',true);
scope2 = dsp.TimeScope('Name','cA DWT of the Signal','TimeSpan',8,'SampleRate',fs,'ShowLegend',true);
scope3 = dsp.TimeScope('Name','cD DWT of the Signal','TimeSpan',8,'SampleRate',fs,'ShowLegend',true);

Hd = [0 -1 5 12 5 -1 0 0]/20*sqrt(2);
Gd = [0 3 -15 -73 170 -73 -15 3]/280*sqrt(2);
Hr = [0 -3 -15 73 170 73 -15 -3]/280*sqrt(2);
Gr = [0 -1 -5 12 -5 -1 0 0]/20*sqrt(2);

fb = dwtfilterbank;
psi = wavelets(fb);
plot(psi);
grid on;
[LoD,HiD,LoR,HiR] = wfilters('sym4');
[Lo, Hi] = filters(fb);
Lo = Lo(:,1);
Hi = Hi(:,1);

[cA, cD] = dwt(sine(),Lo,Hi);
for i=1:15
    scope1(sine());
    scope2(cA);
    scope3(cD);
end

release(scope1);
release(scope2);
release(scope3);
                 