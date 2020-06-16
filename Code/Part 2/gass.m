function [w,e,mu] = gass(signal1,signal2,order,step,leak,rho,algo)
%gass Summary of this function goes here
%   Detailed explanation goes here
N = size(signal1,2);
w = zeros(order,N+1);
e = zeros(1,N);
x = zeros(order,N);
cost = zeros(order,N+1);
mu = zeros(1,N+1);
mu(1) = step;

[~,max_mu] = corrmtx(signal2,0);

for i = 1:order
        x(i, :) = [zeros(1, i), signal1(1:N-i)];
end

for i = 1:N
    pred = w(:,i)'*x(:,i);
    e(:,i) = signal2(:,i) - pred;
    mu(i+1) = mu(i) + rho * e(:,i)*x(:,i)'*cost(:,i);
    if mu(i+1) < 0
        mu(i+1) = 0;
    elseif mu(i+1) > max_mu
        mu(i+1) = max_mu;
    end
    w(:,i+1) = (1-mu(i)*leak) * w(:,i) + mu(i)*e(:,i)*x(:,i);

    switch algo.name
        case 'Benveniste'
            cost(:,i+1) = (eye(order) - mu(i) * x(:,i) * x(:,i)') * cost(:,i) + e(:,i) * x(:,i);
        case 'Ang'
            cost(:,i+1) = algo.param * cost(:,i) + e(:,i) * x(:,i);
        case 'Matthews'
            cost(:,i+1) = e(:,i) * x(:,i);
    end
end
    
w = w(:,2:end);
mu = mu(:,1:end-1);
end

