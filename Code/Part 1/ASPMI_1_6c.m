clear; close all;
%% Initialization

pcr = load('PCR/PCAPCR.mat');
x = pcr.X;
x_noise = pcr.Xnoise;
x_test = pcr.Xtest;
y = pcr.Y;
y_test = pcr.Ytest;
rank_x = rank(x);
%% OLS

b_ols = (x_noise'*x_noise) \ x_noise'*y;

y_ols = x_noise*b_ols;
y_test_ols = x_test*b_ols;

%% PCR

[u_x_noise,s_x_noise,v_x_noise] = svd(x_noise);
x_denoised = u_x_noise(:, 1: rank_x) * s_x_noise(1: rank_x, 1: rank_x) * v_x_noise(:, 1: rank_x)';

[u_x_test,s_x_test,v_x_test] = svd(x_test);
x_test_denoised = u_x_test(:, 1: rank_x) * s_x_test(1: rank_x, 1: rank_x) * v_x_test(:, 1: rank_x)';

b_pcr = v_x_noise(:, 1: rank_x) / s_x_noise(1: rank_x, 1: rank_x) * u_x_noise(:, 1: rank_x)' * y;

y_pcr = x_denoised * b_pcr;
y_test_pcr = x_test_denoised * b_pcr;

%% Square Error

se_ols = vecnorm(y - y_ols) .^ 2;
se_test_ols = vecnorm(y_test - y_test_ols) .^ 2;
sum_error_ols = sum(se_test_ols);

se_pcr = vecnorm(y - y_pcr) .^ 2;
se_test_pcr = vecnorm(y_test - y_test_pcr) .^ 2;
sum_error_pcr = sum(se_test_pcr);

%% Plot Graphs

figure;
subplot(1, 2, 1);
stem(se_ols, '-o');
hold on;
stem(se_pcr, '--x');
grid minor
legend('OLS', 'PCR');
title('OLS vs PCR on Training Set');
xlabel('Column');
ylabel('Square error');
% testing set
subplot(1, 2, 2);
stem(se_test_ols, '-o');
hold on;
stem(se_test_pcr, '--x');
grid minor
legend('OLS', 'PCR');
title('OLS vs PCR on Test Set');
xlabel('Column');
ylabel('Square error');

