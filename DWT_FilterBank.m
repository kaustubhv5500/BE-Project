clc;
clear;
close all;

% Implementation of Filter Bank which uses DWT and IDWT Functions
t = 0.1:0.1:25.6;
x = sin(t + pi);
y = square(t);
z = sawtooth(1.3*t + 1.5*pi);
Tx = [x y z];

load dspwlets;
N = 4; % NumLevels of the filter

x_dwt = dwt(x,hid);
y_dwt = dwt(y,hid);
z_dwt = dwt(z,hid);
Tx_dwt = dwt(Tx,hid);

% Loop to perform multi-level DWT
for i=1:N-1
    x_dwt = dwt(x_dwt,hid);
    y_dwt = dwt(y_dwt,hid);
    z_dwt = dwt(z_dwt,hid);
    Tx_dwt = dwt(Tx_dwt,hid);
end

plot(Tx);
grid on;
title('Original Signal');
figure;

Tx_signal = [x_dwt y_dwt z_dwt];
plot(Tx_dwt);
grid on;
title('Transmitted Signal');
figure;

% Reconstructing the signal using multi-level IDWT
Rx_signal = idwt(Tx_dwt,hid);

for i=1:N-1
    Rx_signal = idwt(Rx_signal,hid);
end

plot(Rx_signal);
grid on;
title('Received Signal');
figure;

error = Tx - Rx_signal;
plot(error);
title('Error Signal');
grid on;

disp('Mean Error: ');
mean_error = mean(error);
disp(mean_error);
