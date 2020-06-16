function [w,pred,e] = perceptron(signal1,signal2,order,step,leak,a, bias,init)
%LMS Summary of this function goes here
%   Detailed explanation goes here
N = size(signal1,2);
w = zeros(order,N+1);
if init ~= 0
    w(:,1) = init; 
end
e = zeros(1,N);
x = zeros(order,N);
pred = zeros(1,N);
for i = 1:order
        x(i, :) = [zeros(1, i), signal1(1:N-i)];
end


for i = 1:N
    pred(:,i) = a*tanh(w(:,i)'*x(:,i) + bias);
    e(:,i) = signal2(:,i) - pred(:,i);
    w(:,i+1) = (1-step*leak) * w(:,i) + step*e(:,i)*x(:,i);
end
    

w = w(:,2:end);
end

