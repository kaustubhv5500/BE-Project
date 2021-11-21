% MATLAB design: 8-point IDWT
% 
% Introduction:
% Performs and returns the Inverse DWT of the input TDM signals as a part of Transmultiplexer operation
% to be transmitted over a communications channel

function [x_out] = mlhdlc_idwt(y_in)

hid = [-0.230377813308855 0.714846570552542 -0.630880767929591 -0.0279837694169839 0.187034811718881 0.0308413818359870 -0.0328830116669830 -0.0105974017849973];

% IDWT of the output
x_out = idwt(y_in,hid);

end


