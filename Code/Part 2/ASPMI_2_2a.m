clear; close all;
%% Initialization

N = 1000;
trials = 100;
ma_coeffs = 0.9;
var = 0.5;
steps = [0.01,0.1];
num_steps = length(steps);
rho = 0.005;
step1 = 0.5;
transient = 400;
J_min = 0.00905;

benveniste.name = 'Benveniste';
benveniste.param = NaN;
ang.name = 'Ang';
ang.param = 0.8;
matthews.name = 'Matthews';
matthews.param = NaN;

model = arima('MA', ma_coeffs, 'Variance', var, 'Constant', 0);
[x,noise] = simulate(model,N,'NumPaths',trials);
x = x';
noise = noise';

%w_lms_avr = zeros(num_steps,N);
w_lms = cell(num_steps,trials);
w_lms_avr = zeros(num_steps,N);
e_lms = cell(num_steps,trials);
e_lms_avr = zeros(num_steps,N);

w_ben = zeros(trials,N);
w_ang = zeros(trials,N);
w_mat = zeros(trials,N);

e_ben = zeros(trials,N);
e_ang = zeros(trials,N);
e_mat = zeros(trials,N);

mu_ben = zeros(trials,N);
mu_ang = zeros(trials,N);
mu_mat = zeros(trials,N);



%% LMS
%signal = [0, maSignal(iRp, 1: end - 1)];
for i = 1:num_steps
    for j = 1:trials
        [w_lms{i,j},~,e_lms{i,j}] = lms(noise(j,:),x(j,:),length(ma_coeffs),steps(i),0,1);
    end
    w_lms_avr(i,:) = mean(cat(3, w_lms{i, :}), 3);
    e_lms_avr(i,:) = mean(cat(3, e_lms{i, :}).^2, 3);
end

emse_lms1 = mean(e_lms_avr(1,800:1000))-J_min;
emse_lms2 = mean(e_lms_avr(2,800:1000))-J_min;

%% GASS

for i = 1:trials
    [w_ben(i,:),e_ben(i,:),mu_ben(i,:)] = gass(noise(i,:), x(i,:), length(ma_coeffs), step1,0, rho, benveniste);
    [w_ang(i,:),e_ang(i,:),mu_ang(i,:)] = gass(noise(i,:), x(i,:), length(ma_coeffs), step1,0, rho, ang);
    [w_mat(i,:),e_mat(i,:),mu_mat(i,:)] = gass(noise(i,:), x(i,:), length(ma_coeffs), step1,0, rho, matthews);
end

w_ben_avr = mean(w_ben);
w_ang_avr = mean(w_ang);
w_mat_avr = mean(w_mat);
mu_ben_avr = mean(mu_ben);
mu_ang_avr = mean(mu_ang);
mu_mat_avr = mean(mu_mat);
error_ben = mean(e_ben.^2);
error_ang = mean(e_ang.^2);
error_mat = mean(e_mat.^2);
emse_ben = mean(error_ben(800:1000))-J_min;
emse_mat = mean(error_mat(800:1000))-J_min;
emse_ang = mean(error_ang(800:1000))-J_min;


%% Plot Graphs
figure
subplot(1,2,1)
for i = 1:num_steps
    plot(ma_coeffs-w_lms_avr(i,:), 'LineWidth',2)
    hold on
end
plot(ma_coeffs-w_ben_avr, 'LineWidth',1)
hold on
plot(ma_coeffs-w_ang_avr,'--', 'LineWidth',1)
hold on
plot(ma_coeffs-w_mat_avr,':', 'LineWidth',1)
grid minor
xlabel('Sample')
ylabel('Error')
title('Weight Error of Standard LMS and GASS')
legend('step=0.01','step=0.1','Benveniste','Ang & Farhang','Matthews & Xie')


subplot(1,2,2)
plot(mu_ben_avr, 'Color','#EDB120', 'LineWidth',2)
hold on
plot(mu_ang_avr, 'Color','#7E2F8E', 'LineWidth',2)
hold on
plot(mu_mat_avr, 'Color','#77AC30','LineWidth',2)
grid minor
xlabel('Sample')
ylabel('Step Size')
title('Step Size Adaption of Different GASS Algorithms')
legend('Benveniste','Ang & Farhang','Matthews & Xie')

figure 
subplot(1,2,1)
plot(pow2db(e_lms_avr(1,:)),'LineWidth',2)
hold on 
plot(pow2db(e_lms_avr(2,:)),'LineWidth',2)
grid minor
legend('step=0.01','step=0.1')
xlabel('Sample')
ylabel('MSE (dB)')
title('Learning Curve for LMS')
subplot(1,2,2)
plot(pow2db(error_ben))
hold on 
plot(pow2db(error_ang),'--')
hold on 
plot(pow2db(error_mat),':')
legend('Benveniste','Ang & Farhang','Matthews & Xie')
grid minor
xlabel('Sample')
ylabel('MSE (dB)')
title('Learning Curve for GASS')




