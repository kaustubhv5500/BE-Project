function f = idwt(g,h)
% function f = idwt(g,h,NJ); Calculates the IDWT of periodic  g
% with scaling filter  h

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script/function was created by 
% Abdullah Al Muhit
% contact - almuhit@gmail.com
% website - https://sites.google.com/site/almuhit/
% Please use it at your own risk. Also, Please cite the following paper:
% A A Muhit, M S Islam, and M Othman, “VLSI Implementation of Discrete Wavelet Transform (DWT) for Image Compression”, in Proc. of The Second International Conference on Autonomous Robots and Agents, Palmerston North, New Zealand, pp. 391-395, 2004, ISBN 0-476-00994-4. [PDF]
% A A Muhit, M S Islam, and M Othman, “ Design Design and Analysis of Discrete Wavelet Transform (DWT) for Image Compression Using VHDL”, in Proc. of the International Conference on Parallel and Distributed Processing Techniques and Applications, PDPTA 2005, Volume 1. CSREA Press 2005, pp. 157-160, Las Vegas, Nevada, USA, 2005, ISBN 1-932415-58-0. [PDF]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

L = length(g);   N = length(h);
h0 = h;                                    % Scaling filter
h1 = fliplr(h);  h1(2:2:N) = -h1(2:2:N);   % Wavelet filter
LJ = L/2;                                  % Number of SF coeffs.

c  = g(1:LJ);                              % Scaling coeffs.
w  = mod(0:N/2-1,LJ)+1;                    % Make periodic
d  = g(LJ+1:L);                            % Wavelet coeffs.
cu(1:2:L+N) = [c c(1,w)];                  % Up-sample & periodic
du(1:2:L+N) = [d d(1,w)];                  % Up-sample & periodic
c  = conv(cu,h0) + conv(du,h1);            % Convolve & combine
c  = c(N:N+L-1);                           % Periodic part
f = c;                                     % The inverse DWT
