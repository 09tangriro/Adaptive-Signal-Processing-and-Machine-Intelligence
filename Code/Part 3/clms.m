function [h,pred,e] = clms(signal,noise,order,step)
%CLMS Summary of this function goes here
%   Detailed explanation goes here
N = size(signal,2);
e = zeros(1,N);
pred = zeros(1,N);
x = zeros(order,N);
h = zeros(order,N+1);

for i = 1:order
    x(i,:) = [zeros(1,i),noise(1:N-i)];
end


for i = 1:N
    pred(:,i) = h(:,i)' * x(:,i);
    e(:,i) = signal(:,i) - pred(:,i);
    h(:,i+1) = h(:,i) + step*conj(e(:,i))*x(:,i);
end

h = h(:,2:end);

end

