clear; close all;
%% Initialization
data = load('time-series.mat');
data = data.y';

n_overfit = 20;
epochs = 100;
bias = 0.11;
n_bias = length(bias);
step = 0.00001;
order = 4;
amps = 48;
n_amps = length(amps);
p = cell(n_bias,n_amps);
e = cell(n_bias,n_amps);
r_p = zeros(n_bias,n_amps);
mse = zeros(n_bias,n_amps);


%% LMS

batch = repmat(data(1: n_overfit), 1, epochs);
for b = 1:n_bias
    for i = 1:n_amps
        [init, ~, ~] = perceptron(batch, batch, order, step, 0, amps(i), bias(b),0);
        init = init(:,end);
        [w,p{b,i},e{b,i}] = perceptron(data,data,order,step,0,amps(i),bias(b),init);
        mse(b,i) = mean(e{b,i}.^2);
        var_output = var(p{b,i});
        var_err = var(e{b,i});

        r_p(b,i) = pow2db(var_output/var_err);
    end
end
%% Plot Graphs

figure
for i = 1:n_amps
    subplot(n_amps,1,i)
    plot(data)
    hold on
    plot(p{1,1},'--')
    grid minor
    legend('Origninal', 'Perceptron')
    xlabel('Sample')
    ylabel('Amplitude')
    title(sprintf('Perceptron (tanh amplitude = %d, bias = %d) Prediction of Zero Mean Non-stationary Data',amps,bias))
end

% 
% figure
% subplot(1,2,1)
% surf(amps,bias,mse)
% colormap(jet) 
% xlabel('Tanh Amplitude')
% ylabel('Bias')
% zlabel('MSE')
% title('MSE')
% subplot(1,2,2)
% surf(amps,bias,r_p)
% colormap(jet) 
% xlabel('Tanh Amplitude')
% ylabel('Bias')
% zlabel('Prediction Gain (dB)')
% title('Prediction Gain')

figure
for i = 1:n_amps
    subplot(n_amps,1,i)
    plot(e{1,1}.^2,'LineWidth',2)
    hold on
    plot(e1{1,1}.^2,'LineWidth',2)
    xlim([0,20])
    legend('No Initialization', 'Initializaiton')
    xlabel('Sample')
    ylabel('Square Error')
    title('Square Error First 20 Samples')
end




