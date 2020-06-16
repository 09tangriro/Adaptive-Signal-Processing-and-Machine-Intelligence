clear; close all;
%% Initialization

data = load('time-series.mat');
data = data.y';

data = data - mean(data);

step = 0.00001;
order = 4;
amps = [25,50,75,100];
n_amps = length(amps);
p = zeros(n_amps,length(data));
e = zeros(n_amps,length(data));
r_p = zeros(n_amps,1);
mse = zeros(n_amps,1);


%% LMS

for i = 1:n_amps
    [w,p(i,:),e(i,:)] = perceptron(data,data,order,step,0,amps(i),0,0);
    mse(i,:) = mean(e(i,:).^2);
    var_output = var(p(i,:));
    var_err = var(e(i,:));

    r_p(i,:) = pow2db(var_output/var_err);
end
%% Plot Graphs

figure
for i = 1:n_amps
    subplot(n_amps,1,i)
    plot(data)
    hold on
    plot(p(i,:),'--')
    grid minor
    legend('Origninal', 'Perceptron')
    xlabel('Sample')
    ylabel('Amplitude')
    title(sprintf('Perceptron (tanh amplitude = %d) Prediction of Zero Mean Non-stationary Data',amps(i)))
end

figure
subplot(1,2,1)
plot(amps,mse,'LineWidth',2)
title('MSE')
xlabel('Tanh Amplitude')
ylabel('MSE')
grid minor
subplot(1,2,2)
plot(amps,r_p,'LineWidth',2)
grid minor
title('Prediction Gain')
xlabel('Tanh Amplitude')
ylabel('Prediction Gain (dB)')





