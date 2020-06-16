clear; close all;
%% Initialization

data = load('time-series.mat');
data = data.y';

data = data - mean(data);

step = 0.00001;
order = 4;

%% LMS

[w,p,e] = perceptron(data,data,order,step,0,1,1,0);
mse = mean(e.^2);
var_output = var(p);
var_err = var(e);

r_p = pow2db(var_output/var_err);

%% Plot Graphs

figure
plot(data)
hold on
grid minor
plot(p)
legend('Origninal', 'Perceptron')
xlabel('Sample')
ylabel('Amplitude')
title('Perceptron (tanh) Prediction of Zero Mean Non-stationary Data')




