function [y] = conv(x,h)
%CONV Redifinition of discrete convolution function to work with HDL Coder
%   Input: Array of elements to be convolved
%   Output: Discrete convolution of input elements
n = length(h) + length(x) - 1;
y = zeros(1,n);

for i=1:n
    sum = 0;
    for j=1:i
        if (((i- j+ 1) <= length(h) ) &&(j <= length(x) ))
            sum = sum + x(j)* h(i- j+ 1);
        end
    end
    y(i) = sum;
end
end

