function [w,e,factor] = gngd(signal1,signal2,order,step,leak,rho)
%LMS Summary of this function goes here
%   Detailed explanation goes here
N = size(signal1,2);
w = zeros(order,N+1);
e = zeros(1,N);
x = zeros(order,N);
factor = ones(1,N+1)/step;
for i = 1:order
        x(i, :) = [zeros(1, i), signal1(1:N-i)];
end

for i = 1:N
    pred =   w(:,i)'*x(:,i);
    e(:,i) = signal2(:,i) - pred;
    w(:,i+1) = (1-leak/factor(i))*w(:,i)+1/(factor(i)+x(:,i)'*x(:,i))*e(:,i)*x(:,i);
    if i > 1
        factor(i+1) = factor(i) - rho*step*e(i)*e(i-1)*x(:,i)'*x(:,i-1) / (factor(i-1)+x(:,i-1)'*x(:,i-1))^2;
    end
end
    

w = w(:,2:end);
factor = factor(:,2:end);
end
