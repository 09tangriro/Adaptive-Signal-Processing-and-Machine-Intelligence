close; clear all;
%% Initialization

N = 1000;
ar_coeffs = [0.1,0.8];
var = 0.25;
trials = 100;
model = arima('AR', ar_coeffs, 'Variance', var, 'Constant', 0);
x = simulate(model, N, 'NumPaths', trials)';
steps = [0.05,0.01];
num_steps = length(steps);
error = zeros(num_steps,N);
e = cell(num_steps,trials);

%% LMS

for i = 1:num_steps
    for j = 1:trials
        x_n = x(j,:);
        [w{i,j},pred,e{i,j}] = lms(x_n,x_n,length(ar_coeffs),steps(i),0,1);
    end
    error(i,:) = pow2db(mean(cat(3, e{i, :}) .^ 2, 3));
    weight{i} = mean(cat(3, w{i, :}), 3);
end


%% Plot Graphs

figure
for i = 1:num_steps
    plot(error(i,:), 'LineWidth',2)
    hold on
end
grid minor
xlabel('Sample')
ylabel('MSE (dB)')
legend('step=0.05','step=0.01')
title('Learning Curve of LMS')
