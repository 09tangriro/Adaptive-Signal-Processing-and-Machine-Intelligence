function [w,pred,e] = lms(signal1,signal2,order,step,leak,delay)
%LMS Summary of this function goes here
%   Detailed explanation goes here
N = size(signal1,2);
w = zeros(order,N+1);
e = zeros(1,N);
x = zeros(order,N);
pred = zeros(1,N);
for i = 1:order
        x(i, :) = [zeros(1, i+delay-1), signal1(1:N-(i+delay-1))];
end

for i = 1:N
    pred(:,i) = w(:,i)'*x(:,i);
    e(:,i) = signal2(:,i) - pred(:,i);
    w(:,i+1) = (1-step*leak) * w(:,i) + step*e(:,i)*x(:,i);
end
    

w = w(:,2:end);
end

