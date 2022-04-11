clc;
clear;
close all;

snr = [-50 -30 -20 -5 10 20 30];
rates = [1.02006 0.042634 0.0009215 0.000165 0.000089 0.0000012 1.7e-7];
conventional_rates = [1.7982 0.728 0.0129 0.00207 0.00087 0.00042  7.1590e-5];

haar_rates = [2.4277 1.20599 0.03880 0.00169 0.00034 0.000098 0.0000027];
symlets_rates = [2.18552 0.33654 0.019020 0.000597 0.00025 0.000021 0.00001];
daubechies_rates = [2.075572 0.352911 0.009020 0.000352 0.00017 0.000012 1.9e-6];
biorth_rates = [2.054686 0.35962  0.013067 0.000447 0.000126 0.000017 2.6e-6];

figure;
semilogy(snr,rates,'-*',snr,conventional_rates,'-o','LineWidth',2);
grid on;
xlabel('SNR (dB)');
ylabel('Mean Error Rate');
title('SNR vs Mean Error Rate for AWGN');
legend('Proposed system','Conventional system');
set(gca,'FontSize',15,'xlim',[-50 30],'XTick',-50:10:30,'YTick',[1e-6 1e-5 1e-4 1e-3 1e-2 1e-1 1]);

figure;
semilogy(snr,rates,'-*',snr,symlets_rates,'-o',snr,daubechies_rates,'-x','LineWidth',2);
grid on;
xlabel('SNR (dB)');
ylabel('Mean Error Rate');
title('SNR vs Mean Error Rate for AWGN');
legend('Proposed system','Symlets','Daubechies');
set(gca,'FontSize',15,'xlim',[-50 30],'XTick',-50:10:30);

figure;
semilogy(snr,rates,'-*',snr,haar_rates,'-^',snr,biorth_rates,'-v','LineWidth',2);
grid on;
xlabel('SNR (dB)');
ylabel('Mean Error Rate');
title('SNR vs Mean Error Rate for AWGN');
legend('Proposed system','Haar','Biorthogonal');
set(gca,'FontSize',15,'xlim',[-50 30],'XTick',-50:10:30);