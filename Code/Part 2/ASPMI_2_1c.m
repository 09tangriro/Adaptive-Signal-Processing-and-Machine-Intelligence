clear; close all;
%% Initialization

N = 1000;
transient = 500;
trials = 100;
ar_coeffs = [0.1,0.8];
steps = linspace(0.01,1,100);
num_steps = length(steps);
var = 0.25;
model = arima('AR', ar_coeffs, 'Variance', var, 'Constant', 0);
x = simulate(model,N,'NumPaths',trials)';
error = zeros(num_steps,trials);
emse_indiv = zeros(num_steps,trials);
corr = [25/27, 25/54; 25/54, 25/27];
t = zeros(num_steps,1);
lowest_eigen = 0.463;

%% LMS

for i = 1:num_steps
    for j = 1:trials
        [~,~,e] = lms(x(j,:),x(j,:),length(ar_coeffs),steps(i),0,1);
        error(i,j) = mean(e(transient+1:end).^2);
        emse_indiv(i,j) = error(i,j)-var;
    end
    t(i) = tc(steps(i),lowest_eigen);
end

emse = mean(emse_indiv, 2);
m = emse / var;

%% Autocorrelation Matrix

m_approx = steps / 2 * trace(corr);
fprintf('Misadjustment: %.4f    %.4f\n', m);
fprintf('Approximated misadjustment: %.4f   %.4f\n', m_approx);

%% Plot Graphs

figure
subplot(1,2,1)
plot(steps,t,'LineWidth',2)
grid minor
xlabel('Step Size')
ylabel('Time Constant')
title('Convergence Speed')
subplot(1,2,2)
plot(steps,pow2db(emse),'LineWidth',2)
grid minor
xlabel('Step Size')
ylabel('EMSE (dB)')
title('Steady State Error')


