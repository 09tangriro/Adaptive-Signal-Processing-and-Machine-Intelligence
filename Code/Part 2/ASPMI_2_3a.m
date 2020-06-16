clear; close all;
%% Initialization

fs = 1;
N = 1000;
trials = 100;
f_sin = 0.005;
t = (0:N-1)/fs;
x = sin(2*pi*f_sin*t);
var = 1;
delays = 4;
step = 0.01;
transient = 50;
order = 5;

ma_coeffs = [0,0.5];
model = arima('MA', ma_coeffs, 'Variance', var, 'Constant', 0);
[n, innovation] = simulate(model, N, 'NumPaths', trials);
n = n';

s = zeros(trials,N);
x_ale = zeros(trials,N);
e = zeros(trials,N-transient);
mse = zeros(delays,N-transient);

%% ALE
for d = 1:delays
    for i = 1:trials
        s(i,:) = x + n(i,:);
        [~,x_ale(i,:),~] = lms(s(i,:),s(i,:),length(ma_coeffs),step,0,d);
        e(i,:) = (x(:,transient + 1: end) - x_ale(i,transient + 1: end)) .^ 2;
    end
    mse(d,:) = mean(e)';
end
mse = mean(mse,2);

%% Plot Graphs
figure
for i = 1: delays
    subplot(delays, 1, i);
    for j = 1: trials
        noisyPlot = plot(t, s(j,:), 'k','LineWidth', 1);
        hold on;
        alePlot = plot(t, x_ale(j,:), 'r', 'LineWidth', 2);
        hold on;
    end
    cleanPlot = plot(t, x, 'LineWidth', 2);
    hold off;
    grid minor
    legend([noisyPlot, alePlot, cleanPlot], {'Noisy', 'ALE', 'Clean'}, 'location', 'bestoutside');
    title(sprintf('Delay = %d', i))
    xlabel('Sample');
    ylabel('Amplitude');
end

figure;
plot(mse,'LineWidth', 2);
grid minor
legend('MSPE');
xlabel('Sample');
ylabel('MSPE');
title('MSPE of ALE for Different Delays')


