% Testing the WT Filter Bank using single input signals

clc;
close all;
clear;

t = 0:.0001:0.0255;
x = [sin(2*pi*420*t) square(2*pi*120*t)];

% t = 0:.0001:.0511;
% xn = x' + 0.08*randn(length(x),1);

load dspwlets;   
dyadicAnalysis = dsp.DyadicAnalysisFilterBank( ...
    'CustomLowpassFilter', lod, ...
    'CustomHighpassFilter', hid, ...
    'NumLevels', 4);

dyadicSynthesis = dsp.DyadicSynthesisFilterBank( ...
    'CustomLowpassFilter',[0 lor], ...
    'CustomHighpassFilter',[0 hir], ...
    'NumLevels', 4);


dydan = dsp.DyadicAnalysisFilterBank;
dydan.CustomLowpassFilter = [1/sqrt(2) 1/sqrt(2)];
dydan.CustomHighpassFilter = [-1/sqrt(2) 1/sqrt(2)];

dydsyn = dsp.DyadicSynthesisFilterBank;
dydsyn.CustomLowpassFilter = [1/sqrt(2) 1/sqrt(2)];
dydsyn.CustomHighpassFilter = [1/sqrt(2) -1/sqrt(2)];
C = dydan(x');

C1 = C(1:256); C2 = C(257:384); C3 = C(385:512);

x_den = dydsyn([zeros(length(C1),1);...
    zeros(length(C2),1);C3]);

release(dydsyn);
release(dydan);

x_tx = dyadicSynthesis(x');
x_out = dyadicAnalysis(x_tx);

subplot(2,1,1), plot(x); grid on; title('Input Signal');
subplot(2,1,2), plot(x_den); grid on; title('Transmitted Signal');