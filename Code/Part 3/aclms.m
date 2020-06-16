function [h,g,pred,e] = aclms(signal,noise,step, order_r, order_c)
%ACLMS Summary of this function goes here
%   Detailed explanation goes here
N = size(signal,2);
noise_ = conj(noise);
e = zeros(1,N);
pred = zeros(1,N);
x = zeros(order_r,N);
x(1,:) = noise;
x_ = zeros(order_c,N);
x_(1,:) = noise_;
h = zeros(order_r,N+1);
g = zeros(order_c,N+1);

for i = 1:order_r
    x(i,:) = [zeros(1,i),noise(1:N-i)];
end

for i = 1:order_c
    x_(i,:) = [zeros(1,i),noise_(1:N-i)];
end

for i = 1:N
    pred(:,i) = h(:,i)' * x(:,i) + g(:,i)' * x_(:,i);
    e(:,i) = signal(:,i) - pred(:,i);
    h(:,i+1) = h(:,i) + step*conj(e(:,i))*x(:,i);
    g(:,i+1) = g(:,i) + step*conj(e(:,i))*x_(:,i);
end

h = h(:,2:end);
g = g(:,2:end);

end

