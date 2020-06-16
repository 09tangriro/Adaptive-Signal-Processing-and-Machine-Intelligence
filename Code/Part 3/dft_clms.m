function [h,e,pred] = dft_clms(x,y,leak)
%DFT_CLMS Summary of this function goes here
%   Detailed explanation goes here

N = size(y,2);
h = zeros(N, N+1);
e = zeros(1,N);
pred = zeros(1,N);


for i = 1:N
    pred(:,i) = h(:, i)' * x(:, i);
    e(:, i) = y(i) - pred(:,i);
    h(:, i + 1) = (1 - leak)*h(:, i) + conj(e(:, i)) * x(:, i);
end

h = h(:, 2: end);
end

