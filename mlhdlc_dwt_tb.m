%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MATLAB test bench for the 8-point DWT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
clear mlhdlc_dwt;

% Implementation of Filter Bank which uses DWT and IDWT Functions
t = 0.1:0.1:25.6;
x = sin(t + pi);
y = square(t);
z = sawtooth(1.3*t + 1.5*pi);

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

plot(Tx);
grid on;
xlabel('Time');
title('Original Signal');

figure;
plot(y_out);
grid on;
xlabel('Time');
title('Transmitted Signal');

figure;
plot(x_out);
xlabel('Time');
title('Received Signal');
grid on;

error = abs(Tx - x_out)./len;
figure;
plot(error);
xlabel('Time');
title('Error Signal');
grid on;