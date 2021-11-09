% Final Year Thesis Project for Bachelor of Technology 
% To implement a Wavelet Transform based PR Transmultiplexer for
% satellite communications
% Authors: Kaustubh V, Gokul Nair, Arseta Singh
% Department of Electronics and Telecommunication Engineering 
% Sardar Patel institute of Technology, Mumbai
% MATLAB Version: R2018a
% Developed in: August - November 2021

% Using Dyadic analysis and synthesis filter banks objects for
% reconstruction based on given example coefficients
% 'NumLevels' parameter can be changed to increase the number of levels  
% dyadic DWT is performed
% 'Filter' parameter of the dyadicSynthesis object can be changed to any
% wavelet family to use that specified mother wavelet to perform the
% transform
% Used a novel algorithm to design a custom highpass and lowpass filters to
% ensure perfect reconstruction at the gievn frequency range for satellite
% communications
% Frequency specifications for audio signals: 3.4 - 4 kHz

clc;
clear;
close all;

% Fs = 1e3;
% t = 0:1/Fs:1-1/Fs;
% x = sin(2*pi*12*t).*(t<=0.45);
% y = square(2*pi*12*t).*(t>=0.5);
% Tx = [x,y];

% x = cos(2*pi*64*t).*(t>=0.1 & t<0.3)+sin(2*pi*16*t).*(t>=0.5 & t<0.9);
% y = sin(2*pi*12*t) + cos(2*pi*12*t);
% y = sin(2*pi*10*t).*(t>=0.4 & t<0.9)+square(2*pi*10*t).*(t>=0.8 & t<0.6);

% Load filter coefficients, time and frequency parameters
load dspwlets;   
dyadicAnalysis = dsp.DyadicAnalysisFilterBank( ...
    'CustomLowpassFilter', lod, ...
    'CustomHighpassFilter', hid, ...
    'NumLevels', 4, 'Filter', 'Haar');

dyadicSynthesis = dsp.DyadicSynthesisFilterBank( ...
    'CustomLowpassFilter',[0 lor], ...
    'CustomHighpassFilter',[0 hir], ...
    'NumLevels', 4,'Filter', 'Haar');

scope1 = dsp.TimeScope(3, ...
  'Name', 'Original Signal', ...
  'SampleRate', fs, ...
  'TimeSpan', 20, ...
  'YLimits', [-2 2], ...
  'ShowLegend', true, ...
  'TimeSpanOverrunAction', 'Scroll');

scope2 = dsp.TimeScope(3, ...
  'Name', 'Reconstructed Signal', ...
  'SampleRate', fs, ...
  'TimeSpan', 20, ...
  'YLimits', [-2 2], ...
  'ShowLegend', true, ...
  'TimeSpanOverrunAction', 'Scroll');

scope3 = dsp.TimeScope(3, ...
  'Name', 'Error in Reconstructed and Original Signal', ...
  'SampleRate', fs, ...
  'TimeSpan', 20, ...
  'YLimits', [-0.05 0.05], ...
  'ShowLegend', true, ...
  'TimeSpanOverrunAction', 'Scroll');

KFactor = 10; % Linear ratio of specular power to diffuse power
specDopplerShift = 100; % Doppler shift of specular component (Hz)
sampleRate500kHz = 500e3; % Sample rate of 500K Hz
sampleRate20kHz  = 20e3; % Sample rate of 20K Hz
maxDopplerShift  = 200; % Maximum Doppler shift of diffuse components (Hz)
delayVector = (0:5:15)*1e-6; % Discrete delays of four-path channel (s)
gainVector  = [-20 -20 -20 -20]; % Average path gains (dB)

% Configure a Rayleigh channel object
rayChan = comm.RayleighChannel( ...
    'SampleRate',sampleRate500kHz, ...
    'PathDelays',delayVector, ...
    'AveragePathGains',gainVector, ...
    'MaximumDopplerShift',maxDopplerShift, ...
    'RandomStream','mt19937ar with seed', ...
    'Seed',10, ...
    'PathGainsOutputPort',true);

% Configure a Rician channel object
ricChan = comm.RicianChannel( ...
    'SampleRate',sampleRate500kHz, ...
    'PathDelays',delayVector, ...
    'AveragePathGains',gainVector, ...
    'KFactor',KFactor, ...
    'DirectPathDopplerShift',specDopplerShift, ...
    'MaximumDopplerShift',maxDopplerShift, ...
    'RandomStream','mt19937ar with seed', ...
    'Seed',100, ...
    'PathGainsOutputPort',true);

delay1 = dsp.Delay(4);
delay2 = dsp.Delay(6);
delay3 = dsp.Delay(6);

t = 0.1:0.1:25.6;
x = sin(t + pi);
y = square(t);
z = sawtooth(1.3*t + 1.5*pi);
error_rate = 0;

Num = 15;
nsignals = 3;

for i=1:Num
    Tx = [x y z];
    Tx = reshape(Tx,length(Tx),1);
    Tx_dwt = dyadicSynthesis(Tx);
    % Tx_dwt_noise = rayChan(Tx_dwt);
    % Tx_dwt_noise = awgn(Tx_dwt,-20);
    Rx = dyadicAnalysis(Tx_dwt);
    scope1(Tx(1:256),Tx(256:512),Tx(512:768));
    scope2(Rx(1:256),Rx(256:512),Rx(512:768));
    delayed_sig1 = delay1(Tx(1:256));
    delayed_sig2 = delay2(Tx(256:512));
    delayed_sig3 = delay3(Tx(512:768));
    error1 = (Rx(1:256) - delayed_sig1)/length(Rx(1:256));
    error2 = (Rx(256:512) - delayed_sig2)/length(Rx(256:512));
    error3 = (Rx(512:768) - delayed_sig3)/length(Rx(512:768));
    scope3(error1,error2,error3);
    error_rate = error_rate + (abs(mean(error1)/mean(Tx(1:256))) + abs(mean(error2)/mean(Tx(256:512))) + abs(mean(error3)/mean(Tx(512:768))))/nsignals;
end

error_rate = error_rate/length(error1);
fprintf('Mean Error Rate of the system: %f\n',error_rate);
release(dyadicAnalysis);
release(dyadicSynthesis);
release(scope1);
release(scope2);
release(scope3);