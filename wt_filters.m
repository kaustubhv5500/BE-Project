clc;
clear;
close all;

% Declaring the polynomial co-efficients based on the given design specifications
T00 = [0.0024,-0.015,0.0231,0.045,-0.15,-0.0424,0.316,0.0257,-0.316,-0.0424,0.15,0.0447,-0.023,-0.0152,-0.0025];
T11 = [-0.0024,-0.0152,-0.0231,0.0447,0.1496,-0.0424,-0.3163,0.0257,0.3163,-0.0424,-0.1496,0.0447,0.0231,-0.0152,0.0024];
T22 = [0.0207,0,-0.2032,0,1.0159,0,-5.0795,8.4921,-5.0795,0,1.0159,0,-0.2032,0,0.0207];

% Creating polynomials to be factored
HG00 = poly2sym(sym(T00));
HG11 = poly2sym(sym(T11));
HG22 = poly2sym(sym(T22));
syms x;

% Factoring the polynomials into Analysis and Synthesis parts
lod = factor(HG00,x,'FactorMode','real');
hid = factor(HG00,x,'FactorMode','full');
lor = factor(HG11,x,'FactorMode','real');
hir = factor(HG11,x,'FactorMode','full');
lof = factor(HG22,x,'FactorMode','real');
hif = factor(HG22,x,'FactorMode','full');

load dspwlets;
lof = hid./(sqrt(sum(hid))*1e7);
hif = hir./(sqrt(sum(hir))*1e7);
% lod = [-0.0105974017849973 0.0328830116669830 0.0308413818359870 -0.187034811718881 -0.0279837694169839 0.630880767929591 0.714846570552542 0.230377813308855];
% hid = [-0.230377813308855 0.714846570552542 -0.630880767929591 -0.0279837694169839 0.187034811718881 0.0308413818359870 -0.0328830116669830 -0.0105974017849973];
% hir = [-0.0105974017849973 -0.0328830116669830 0.0308413818359870 0.187034811718881 -0.0279837694169839 -0.630880767929591 0.714846570552542 -0.230377813308855];
% lor = [0.230377813308855 0.714846570552542 0.630880767929591 -0.0279837694169839 -0.187034811718881 0.0308413818359870 0.0328830116669830 -0.0105974017849973];
% fs = 80;
% ts = 1;

% Plotting the frequency and phase response plots of the filters
freqz(lod,1,fs);
figure;
freqz([0 lor],1,fs);
figure;
freqz(hid,1,fs);
figure;
freqz([0 hir],1,fs);
figure;
freqz(lof,1,fs);
figure;
freqz(hif,1,fs);