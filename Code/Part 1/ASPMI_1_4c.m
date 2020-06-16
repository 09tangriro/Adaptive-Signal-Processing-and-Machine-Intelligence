clear; close all; 
%% Initialization

n = 10000;
n_discard = 500;
n_result = n-n_discard;
t = linspace(0,n_result-1,n_result);
fs = 1;
f = t ./ (2 * n_result) * fs;
a = [2.76,-3.81,2.65,-0.92];
std = 1;
mean = 0;
orders = 2:14;

%% AR process

model_true = arima('Constant',0, 'AR', a, 'Variance',std);
x = simulate(model_true,n);
x = x(n_discard:n);

psd_true = pow2db(abs(freqz(std, [1 -a], n_result, fs)).^2); 
%% AR model
psd = cell(length(orders),1);
mse = zeros(length(orders),1);
mdl = zeros(length(orders),1);
aic = zeros(length(orders),1);
for i = orders
    [a_est,var_est] = aryule(x,i);
    psd{i-1} = pow2db(abs(freqz(sqrt(var_est), a_est, n_result, fs)).^2);
    mse(i-1) = sum((psd{i-1}-psd_true).^2)/n_result;
    mdl(i-1) = log(mse(i-1)) + (i*log(n_result))/n_result;
    aic(i-1) = log(mse(i-1)) + ((2*i)/n_result);
end

%% Plot Graphs
figure
subplot(3,1,1)
plot(f,psd_true,'LineWidth',2)
hold on
index = 2;
labels{1} = 'true';
for i = 1:5
    plot(f,psd{i})
    hold on
    labels{index} = strcat('order=', int2str(i+1));
    index = index + 1;
end
grid minor
title('PSD of AR Process ')
xlabel('Normalized Frequency (cycles/sample)')
ylabel('PSD (dB)')
legend('true',labels);
subplot(3,1,2)
plot(orders,mse,'LineWidth',2)
grid minor
title('MSE of AR Order Estimate')
xlabel('Order')
ylabel('Error')
subplot(3,1,3)
plot(orders,mdl,'LineWidth',2)
hold on
plot(orders,aic,'--','LineWidth',2)
grid minor
title('Model Order Selection Criterion')
xlabel('Order')
ylabel('Weighted Error')
legend('MDL','AIC')
