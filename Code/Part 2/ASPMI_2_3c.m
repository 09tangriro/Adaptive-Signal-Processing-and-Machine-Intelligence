clear; close all;
%% Initialization

fs = 1;
N = 1000;
trials = 100;
f_sin = 0.005;
t = (0:N-1)/fs;
x = sin(2*pi*f_sin*t);
var = 1;
delay = 3;
step = 0.01;
transient = 0;
order = 5;

ma_coeffs = [0,0.5];
model = arima('MA', ma_coeffs, 'Variance', var, 'Constant', 0);
[n, innovation] = simulate(model, N, 'NumPaths', trials);
n = n';

secondary_noise = 2*n +0.08;

s = zeros(trials,N);
x_ale = zeros(trials,N);
e_ale = zeros(trials,N-transient);

n_anc = zeros(trials,N);
x_anc = zeros(trials,N);
e_anc = zeros(trials,N-transient);

%% ALE and ANC
for i = 1:trials
    s(i,:) = x + n(i,:);
    [~,x_ale(i,:),~] = lms(s(i,:),s(i,:),length(ma_coeffs),step,0,delay);
    e_ale(i,:) = (x(:,transient + 1: end) - x_ale(i,transient + 1: end)) .^ 2;
    
    [~,n_anc(i,:),~] = lms(secondary_noise(i,:),s(i,:),order,step,0,0);
    x_anc(i,:) = s(i,:)-n_anc(i,:);
    e_anc(i,:) = (x(:,transient + 1: end) - x_anc(i,transient + 1: end)) .^ 2;
end
mspe_ale = mean(e_ale);
mspe_ale = mean(mspe_ale);

mspe_anc = mean(e_anc);
mspc_anc = mean(mspe_anc);

x_anc = mean(x_anc);
x_ale = mean(x_ale);


%% Plot Graphs
figure
for i = 1:trials
    noisy_plot = plot(s(i,:), 'k');
    hold on
end
clean_plot = plot(x,':r','LineWidth',2);
hold on
ale_plot = plot(x_ale,'LineWidth',2);
hold on
anc_plot = plot(x_anc, 'LineWidth',2);
grid minor
xlabel('Sample')
ylabel('Amplitude')
title('Comparison of ANC and ALE Algorithms')
legend([noisy_plot,clean_plot,ale_plot,anc_plot],{'Noisy','Clean','ALE','ANC'})

