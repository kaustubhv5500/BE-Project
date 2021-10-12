% Final Year Thesis Project for Bachelor of Technology 
% To implement a Wavelet Transform based PR Transmultiplexer for
% satellite communications
% Authors: Kaustubh V, Gokul Nair, Arseta Singh
% Department of Electronics and Telecommunication Engineering 
% Sardar Patel institute of Technology, Mumbai
% MATLAB Version: R2018a

% Using Dyadic analysis and synthesis filter banks objects for
% reconstruction based on given example coefficients
% 'NumLevels' parameter can be changed to increase the number of levels  
% dyadic DWT is performed
% Used a novel algorithm to design a custom highpass and lowpass filters to
% ensure perfect reconstruction at the gievn frequency range for satellite
% communications
% Frequency specifications for audio signals: 3.4-4 kHz

clc;
clear;
close all;

Fs = 1e3;
t = 0:1/Fs:1-1/Fs;
x = sin(2*pi*12*t).*(t<=0.45);
y = square(2*pi*12*t).*(t>=0.5);
Tx = [x,y];
% x = cos(2*pi*64*t).*(t>=0.1 & t<0.3)+sin(2*pi*16*t).*(t>=0.5 & t<0.9);
% y = sin(2*pi*12*t) + cos(2*pi*12*t);
% y = sin(2*pi*10*t).*(t>=0.4 & t<0.9)+square(2*pi*10*t).*(t>=0.8 & t<0.6);

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

delay1 = dsp.Delay(4);
delay2 = dsp.Delay(6);

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
    delayed_sig1 = delay1(Tx(1:256));
    delayed_sig2 = delay2(Tx(256:512));
    error1 = (Rx(1:256) - delayed_sig1)/length(Rx(1:256));
    error2 = (Rx(256:512) - delayed_sig2)/length(Rx(256:512));
    scope3(error1,error2);
    error_rate = error_rate + (abs(mean(error1)/mean(Tx(1:256))) + abs(mean(error2)/mean(Tx(256:512))))/2;
end

error_rate = error_rate/length(error1);
fprintf('Mean Error Rate of the system: %f\n',error_rate);
release(dyadicAnalysis);
release(dyadicSynthesis);
release(scope1);
release(scope2);
release(scope3);