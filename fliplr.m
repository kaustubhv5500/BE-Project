function [y] = fliplr(x)
%FLIPLR Redefinition of MATLAB  fliplr function
%   Reverses the input array
N = length(x);
y = zeros(1,N);
for i=1:N
    y(N-i+1) = x(i);
end
end

