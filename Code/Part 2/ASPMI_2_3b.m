clear; close all;
%% Initialization

fs = 1;
N = 1000;
M = [5,10,15,20];
trials = 100;
n_orders = length(M);
f_sin = 0.005;
t = (0:N-1)/fs;
x = sin(2*pi*f_sin*t);
var = 1;
delays = 3:25;
n_delays = length(delays);
step = 0.01;
transient = 50;
order = 5;

ma_coeffs = [0,0.5];
model = arima('MA', ma_coeffs, 'Variance', var, 'Constant', 0);
[n, innovation] = simulate(model, N, 'NumPaths', trials);
n = n';

s = zeros(trials,N);
e = cell(n_orders, n_delays, trials);
mspe = zeros(n_orders, n_delays);

%% ALE
for m = 1:n_orders
    for d = 1:n_delays
        for i = 1:trials
            s(i,:) = x + n(i,:);
            [~,x_ale,~] = lms(s(i,:),s(i,:),M(:,m),step,0,delays(:,d));
            e{m,d,i} = (x(:,transient + 1: end) - x_ale(:,transient + 1: end)) .^ 2;
        end
        mspe(m,d) = mean(cell2mat(e(m,d,:)), 'all');
    end
end

%% Plot Graphs
figure
for i = 1:n_orders
    plot(delays,mspe(i,:),'LineWidth',2)
    hold on
end
grid minor
xlim([3,25])
legend(sprintf('M = %d', M(1)),sprintf('M = %d', M(2)),sprintf('M = %d', M(3)),sprintf('M = %d', M(4)),'Location','northwest')
xlabel('Delay')
ylabel('MSPE')
title('MSPE vs Order vs Delay')



