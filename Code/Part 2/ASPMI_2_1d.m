clear; close all;

%% Initialization

N = 1000;
transient = 500;
trials = 100;
ar_coeffs = [0.1,0.8];
steps = [0.05,0.01];
steps_label = ["0.05","0.01"];
num_steps = length(steps);
var = 0.25;
model = arima('AR', ar_coeffs, 'Variance', var, 'Constant', 0);
x = simulate(model,N,'NumPaths',trials)';
w = cell(num_steps,trials);
w_avr = cell(num_steps,1);

%% LMS

for i = 1:num_steps
    for j = 1:trials
        [w{i,j},~] = lms(x(j,:),x(j,:),length(ar_coeffs),steps(i),0,1);
    end
    w_avr{i} = mean(cat(3, w{i, :}), 3);
end

%% Plot Graphs

figure
for i = 1:num_steps
    plot(w_avr{i}(1,:),'LineWidth',2)
    hold on
    plot(w_avr{i}(2,:),'LineWidth',2)
    hold on
end
grid minor
xlabel('Sample')
ylabel('Average Weight')
title('Weights for AR Coefficients')
legend('a1,step=0.05','a2,step=0.05','a1,step=0.01','a2,step=0.01')
xlim([0,1000])


