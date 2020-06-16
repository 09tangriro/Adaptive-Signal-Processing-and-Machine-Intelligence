clear; close all;
%% Initialization

pcr = load('PCR/PCAPCR.mat');
x = pcr.X;
x_noise = pcr.Xnoise;
y = pcr.Y;
rank_x = rank(x);
trials = 1000;
%% OLS

b_ols = (x_noise'*x_noise) \ x_noise'*y;

%% PCR

[u_x_noise,s_x_noise,v_x_noise] = svd(x_noise);
x_denoised = u_x_noise(:, 1: rank_x) * s_x_noise(1: rank_x, 1: rank_x) * v_x_noise(:, 1: rank_x)';

b_pcr = v_x_noise(:, 1: rank_x) / s_x_noise(1: rank_x, 1: rank_x) * u_x_noise(:, 1: rank_x)' * y;

%% Tests
se_ols = cell(trials,1);
se_pcr = cell(trials,1); 
for i = 1:trials
    [y_test,y_test_ols] = regval(b_ols);
    se_ols{i} = vecnorm(y_test - y_test_ols) .^ 2;
    [y_test,y_test_pcr] = regval(b_pcr);
    se_pcr{i} = vecnorm(y_test - y_test_pcr) .^ 2;
end

mse_ols = mean(cell2mat(se_ols));
mse_pcr = mean(cell2mat(se_pcr));

ols_error = sum(mse_ols);
pcr_error = sum(mse_pcr);
%% Plot Graphs

figure;
stem(mse_ols, '-o');
hold on;
stem(mse_pcr, '--x');
grid minor
legend('OLS', 'PCR');
title('MSE of OLS vs PCR for 1000 trials');
xlabel('Column');
ylabel('MSE');