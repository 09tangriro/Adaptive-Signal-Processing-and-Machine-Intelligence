clear; close all;

%% Initialization

pcr = load('PCR/PCAPCR.mat');
x = pcr.X;
x_noise = pcr.Xnoise;

%% Get SVDs and rank
svd_x = svd(x);
svd_x_noise = svd(x_noise);
[u_x,s_x,v_x] = svd(x);
[u_x_noise,s_x_noise,v_x_noise] = svd(x_noise);
rank_x = rank(x);

%% Create Low Rank Approximation

x_denoised = u_x_noise(:, 1: rank_x) * s_x_noise(1: rank_x, 1: rank_x) * v_x_noise(:, 1: rank_x)';

%% Square Error
se_noise = vecnorm(x-x_noise).^2;
se_denoised = vecnorm(x-x_denoised).^2;

%% Plot Graphs

figure;
stem(se_noise, '-x');
hold on;
stem(se_denoised, '--o');
grid minor
legend('Noisy signal', 'Denoised signal');
title('Square Error Compared to the Clean Signal');
xlabel('Column');
ylabel('Square error');
