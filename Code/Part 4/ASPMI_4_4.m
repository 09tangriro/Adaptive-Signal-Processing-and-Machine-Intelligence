%clear; close all;
%% Initialization
data = load('time-series.mat');
data = data.y';

bias = 0.12;
n_bias = length(bias);
step = 0.00001;
order = 4;
amps = 51;
n_amps = length(amps);
p = cell(n_bias,n_amps);
e1 = cell(n_bias,n_amps);
r_p = zeros(n_bias,n_amps);
mse = zeros(n_bias,n_amps);


%% LMS
for b = 1:n_bias
    for i = 1:n_amps
        [w,p{b,i},e1{b,i}] = perceptron(data,data,order,step,0,amps(i),bias(b),0);
        mse(b,i) = mean(e1{b,i}.^2);
        var_output = var(p{b,i});
        var_err = var(e1{b,i});

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

figure
for i = 1:n_amps
    subplot(n_amps,1,i)
    plot(e1{1,1}.^2,'LineWidth',2)
    hold on
    plot(e{1,1}.^2,'LineWidth',2)
    grid minor
    legend('No Initialization','Initialization')
    xlim([0,20])
    xlabel('Sample')
    ylabel('Square Error')
    title('Error First 20 Samples')
end

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





