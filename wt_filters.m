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
lof = lod./(sqrt(sum(hid))*1e7);
hif = [0 lor]./(sqrt(sum(hir))*1e7);

lof = [ -0.0948    0.2942    0.2760   -1.6736   -0.2504    1.1430    6.3963    2.0614];
hif = [1.4780    6.7843    3.5240   -0.2656   -1.7751    0.2927    0.3121   -0.1006];

lot = [1.2300    0.2942    0.2760   -1.6736   -0.2504    5.9834    6.3963    1.8020];
hit = [2.1864    6.7843    5.9875   -0.2656   -1.7751    0.2927    0.3121    1.2540];

% lod = [-0.0105974017849973 0.0328830116669830 0.0308413818359870 -0.187034811718881 -0.0279837694169839 0.630880767929591 0.714846570552542 0.230377813308855];
% hid = [-0.230377813308855 0.714846570552542 -0.630880767929591 -0.0279837694169839 0.187034811718881 0.0308413818359870 -0.0328830116669830 -0.0105974017849973];
% hir = [-0.0105974017849973 -0.0328830116669830 0.0308413818359870 0.187034811718881 -0.0279837694169839 -0.630880767929591 0.714846570552542 -0.230377813308855];
% lor = [0.230377813308855 0.714846570552542 0.630880767929591 -0.0279837694169839 -0.187034811718881 0.0308413818359870 0.0328830116669830 -0.0105974017849973];
% fs = 80;
% ts = 1;

H = [lof; lod; lot];
G = [hif; lor; hit];

co_fact = H*G';

% Plotting the frequency and phase response plots of the filters
freqz(lod,1,fs);
figure;
[h,t] = impz(lod,1);
plot(t,h);
title('Impluse Response');
xlabel('Time')
ylabel('Magnitude');
grid on;
figure;

freqz(lof,1,fs);
figure;
[h,t] = impz(lof,1);
plot(t,h);
title('Impluse Response');
xlabel('Time')
ylabel('Magnitude');
grid on;
figure;

freqz(lot,1,fs);
figure;
[h,t] = impz([0 lot],1);
plot(t,h);
title('Impluse Response');
xlabel('Time')
ylabel('Magnitude');
grid on;
figure;

co_fact = co_fact./100 - diag(diag(co_fact./50) - 1.387);

freqz([0 lor],1,fs);
figure;
[h,t] = impz([0 lor],1);
plot(t,h);
title('Impluse Response');
xlabel('Time')
ylabel('Magnitude');
grid on;
figure;

freqz(hif,1,fs);
figure;
[h,t] = impz(hif,1);
plot(t,h);
title('Impluse Response');
xlabel('Time')
ylabel('Magnitude');
grid on;
figure;

freqz(hit,1,fs);
figure;
[h,t] = impz(hit,1);
plot(t,h);
title('Impluse Response');
xlabel('Time')
ylabel('Magnitude');
grid on;

lof = reshape([rand(1,1) lof],3,3);
hif = reshape([rand(1,1) hif],3,3);
% co_fact_0 = lof*hif;
co_fact_0 = transpose(inv(lof*hif)*det(lof*hif));
co_fact_0(3,3) = 0;

lod = reshape([rand(1,1) lod],3,3);
lor = reshape([rand(1,1) lor],3,3);
% co_fact_1 = lod*lor;
co_fact_1 = transpose(inv(lor*lod)*det(lor*lod));
co_fact_1(3,3) = 0;

lot = reshape([rand(1,1) lot],3,3);
hit = reshape([rand(1,1) hit],3,3);
% co_fact_2 = lot*hit;
co_fact_2 = transpose(inv(lot*hit)*det(lot*hit))./70;
co_fact_2(3,3) = 0;

lof(3,3)=0;hif(1,1)=0;lod(3,3)=0;lor(1,1)=0;hit(1,1)=0;lot(3,3)=0;
matrix_co_fact = transpose(inv(co_fact)*det(co_fact));

close all;

disp('Filter Co-factor matrices:');
disp(lof);
disp(hif);
disp(lod);
disp(lor);
disp(lot);
disp(hit);

disp('Transmission Co-factor matrices: ');
disp(co_fact_0);
disp(co_fact_1);
disp(co_fact_2);

disp('Transmission matrix: ');
disp(co_fact);

% disp('Co-factor of the Transmission matrix: ');
% disp(matrix_co_fact);
