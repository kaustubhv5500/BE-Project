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

% Loop to perform multi-level DWT
for i=1:N-1
    x_dwt = dwt(x_dwt,hid);
    y_dwt = dwt(y_dwt,hid);
    z_dwt = dwt(z_dwt,hid);
end

Tx_dwt = [x_dwt y_dwt z_dwt];

x_out_dwt = Tx_dwt(1:256);
y_out_dwt = Tx_dwt(257:512);
z_out_dwt = Tx_dwt(513:768);

x_out = idwt(x_out_dwt,hid);
y_out = idwt(y_out_dwt,hid);
z_out = idwt(z_out_dwt,hid);

Tx_out = idwt(Tx_dwt,hid);

for ii=1:N-1
    Tx_out = idwt(Tx_out,hid);
    x_out = idwt(x_out,hid);
    y_out = idwt(y_out,hid);
    z_out = idwt(z_out,hid);
end

plot(Tx);
title('Original Signal');
grid on;
xlabel('Time');

figure;
plot(Tx_dwt);
title('Transmitted Signal');
grid on;
xlabel('Time');

figure;
plot(Tx_out);
title('Recovered Signal');
grid on;
xlabel('Time');

figure;
plot([x_out y_out z_out]);
title('Output Signal');
grid on;
xlabel('Time');

error = Tx - [x_out y_out z_out];
figure;
plot(error);
grid on;
title('Error Signal');
xlabel('Time');



