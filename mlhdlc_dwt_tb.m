%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MATLAB test bench for the 8-point DWT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
clear mlhdlc_dwt;
clear;

% Implementation of Filter Bank which uses DWT and IDWT Functions
t = 0.1:0.1:25.6;
x = sin(t + pi);
y = square(t);
z = sawtooth(1.3*t + 1.5*pi);

% [x,fs] = audioread("./audio/OSR_us_000_0037_8k.wav");
% [y, fs] = audioread("./audio/OSR_us_000_0012_8k.wav");
% exp = floor(log2(length(x)));
% l = 2^exp;
% t = linspace(0,11*pi,l);
% 
% x = reshape(x(1:l),1,l);
% y = reshape(y(1:l),1,l);
% z = square(l*t);

hid = [-0.230377813308855 0.714846570552542 -0.630880767929591 -0.0279837694169839 0.187034811718881 0.0308413818359870 -0.0328830116669830 -0.0105974017849973];
Tx = [x y z];
len = length(Tx);

N = 8;
n = len/N;
Num_Levels = 4;
y_out = zeros(1,8);
x_out = zeros(1,8);

for ii=1:n
    data = Tx(ii*N-N+1:ii*N);
    % call to the design 'mlhdlc_dwt' that is targeted for hardware
    temp_y = mlhdlc_dwt(data);
    y_out = [y_out temp_y];
    % [y_out(ii),x_out(ii)] = mlhdlc_dwt(data);
end

for ii=1:n
    temp_y = y_out(ii*N-N+1:ii*N);
    temp_x = idwt(temp_y,hid);
    x_out = [x_out temp_x];
end

x_out = x_out(N+1:length(x_out));

plot(t,x,t,y,t,z,'LineWidth',2);
grid on;
xlabel('Time');
ylabel('Amplitude');
title('Original Signal');
legend('Channel 1','Channel 2','Channel 3');

figure;
plot(y_out);
grid on;
xlabel('Time');
title('Transmitted Signal');

figure;
plot(t,x_out(1:256),t,x_out(257:512),t,x_out(513:768),'LineWidth',2);
xlabel('Time');
ylabel('Amplitude');
title('Received Signal');
legend('Channel 1','Channel 2','Channel 3');
grid on;

error = abs(Tx - x_out)./len;
figure;
plot(t,error(1:256),t,error(257:512),t,error(513:768),'LineWidth',2);
xlabel('Time');
ylabel('Amplitude');
legend('Channel 1','Channel 2','Channel 3');
title('Error Signal');
grid on;

% x_ = x_out(1:l);
% y_ = x_out(l+1:2*l);
% z_ = x_out(2*l+1:3*l);

% Audio playback after reconstruction
% sound(x_,fs);
% sound(y_,fs);