% MATLAB design: 8-point Discrete WT
% 
% Introduction:
% Performs and returns the DWT of the input TDM signals as a part of Transmultiplexer operation
% to be transmitted over a communications channel

function [y_out] = mlhdlc_dwt(x_in)

hid = [-0.230377813308855 0.714846570552542 -0.630880767929591 -0.0279837694169839 0.187034811718881 0.0308413818359870 -0.0328830116669830 -0.0105974017849973];

% declare and initialize the delay registers
persistent ud1 ud2 ud3 ud4 ud5 ud6 ud7 ud8;
if isempty(ud1)
    ud1 = 0; ud2 = 0; ud3 = 0; ud4 = 0; ud5 = 0; ud6 = 0; ud7 = 0; ud8 = 0;
end

% access the previous value of states/registers
a1 = ud1;
a2 = ud2;
a3 = ud3;
a4 = ud4;
a5 = ud5;
a6 = ud6;
a7 = ud7;
a8 = ud8;

x = [a1 a2 a3 a4 a5 a6 a7 a8];

% DWT of the output
y_out = dwt(x_in,hid);

% delayout input signal
% x_out = idwt(y_out,hid);

% update the delay line
% ud8 = ud7; 
% ud7 = ud6;
% ud6 = ud5;
% ud5 = ud4;
% ud4 = ud3;
% ud3 = ud2;
% ud2 = ud1;
% ud1 = x_in;

end


