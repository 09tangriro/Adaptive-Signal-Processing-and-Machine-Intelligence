clear; close all;
%% Initialization

pcr = load('PCR/PCAPCR.mat');
x = pcr.X;
x_noise = pcr.Xnoise;

%% Get SVDs and Ranks

svd_x = svd(x);
svd_x_noise = svd(x_noise);
rank_x = rank(x);

%% Square Error

se = (svd_x-svd_x_noise).^2;

%% Plot Graphs

figure;
subplot(1, 2, 1);
stem(svd_x_noise, '-x');
hold on;
stem(svd_x, '--o');
grid minor
legend('Noisy signal', 'Clean signal');
title('Singular Values of Noisy and Clean Signal');
xlabel('Column');
ylabel('Singular value');
% square error
subplot(1, 2, 2);
stem(se);
grid minor
legend('square error');
title('Square Error between Singular Values of Noisy and Clean Signal');
xlabel('Column');
ylabel('Squared error');

