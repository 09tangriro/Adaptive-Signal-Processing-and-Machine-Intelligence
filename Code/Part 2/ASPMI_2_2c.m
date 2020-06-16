%clear; close all;
%% Initialization

N = 1000;
trials = 100;
ma_coeffs = 0.9;
var = 0.5;
rho = linspace(0.0001,0.01,50);
n_rho = length(rho);
transient = 200;
J_min = 0.00905;

benveniste.name = 'Benveniste';
benveniste.param = NaN;

model = arima('MA', ma_coeffs, 'Variance', var, 'Constant', 0);
[x,noise] = simulate(model,N,'NumPaths',trials);
x = x';

noise = noise';
step_ben = linspace(0,1,11);
step_gngd = linspace(0,7,11);
n_step_ben = length(step_ben);
n_step_gngd = length(step_gngd);

w_ben = zeros(trials,N);
w_ben_avr = cell(n_rho,n_step_ben);
e_ben = zeros(trials,N);
e_ben_avr = cell(n_rho,n_step_ben);
mu_ben = zeros(trials,N);
mu_ben_avr = cell(n_rho,n_step_ben);
w_gngd = zeros(trials,N);
w_gngd_avr = cell(n_rho,n_step_gngd);
e_gngd = zeros(trials,N);
e_gngd_avr = cell(n_rho,n_step_gngd);
mse_ben = zeros(n_rho,n_step_ben);
mse_gngd = zeros(n_rho,n_step_gngd);


%% GASS
for s = 1:n_step_ben
    for j = 1:n_rho
        for i = 1:trials
            [w_ben(i,:), e_ben(i,:),mu_ben(i,:)] = gass(noise(i,:),x(i,:),length(ma_coeffs),step_ben(s),0,rho(j),benveniste);
        end
        w_ben_avr{j,s} = 0.9-mean(w_ben);
        e_ben_avr{j,s} = mean(e_ben(:,201:1000).^2);
        mu_ben_avr{j,s} = mean(mu_ben);
        mse_ben(j,s) = mean(e_ben_avr{j,s});
    end
end
emse_ben = mse_ben-J_min;

%% GNGD
for s = 1:n_step_gngd
    for j = 1:n_rho
        for i = 1:trials
            [w_gngd(i,:),e_gngd(i,:),d] = gngd(noise(i,:),x(i,:),length(ma_coeffs),step_gngd(s),0,rho(j));
        end
        w_gngd_avr{j,s} = 0.9-mean(w_gngd);
        e_gngd_avr{j,s} = mean(e_gngd(:,201:1000).^2); 
        mse_gngd(j,s) = mean(e_gngd_avr{j,s});
    end
end

emse_gngd = mse_gngd-J_min;

%% Plot Graphs

figure
subplot(1,2,1)
surf(step_ben,rho,pow2db(emse_ben))
colormap(jet)
xlabel('Step Size')
ylabel('rho')
zlabel('EMSE (dB)')
title('Benveniste GASS Steady State Statistics')
subplot(1,2,2)
surf(step_gngd,rho,pow2db(emse_gngd))
colormap(jet)
xlabel('Step Size')
ylabel('rho')
zlabel('EMSE (dB)')
title('GNGD Steady State Statistics')


figure
plot(rho, pow2db(emse_ben(:,6)), 'LineWidth',2)
hold on
plot(rho,pow2db(emse_gngd(:,11)),'LineWidth',2)
grid minor
legend('Benveniste','GNGD')
xlabel('rho')
ylabel('EMSE (dB)')
title('Steady State Performance Against rho')
% 
% figure
% subplot(1,2,1)
% plot(w_ben_avr, 'LineWidth',2)
% hold on
% plot(w_gngd_avr,':', 'LineWidth',2)
% xlabel('Sample')
% ylabel('Weight Error')
% title('Transient Weight Error Approximation of Benveniste and GNGD Algorithms')
% legend('Benveniste','GNGD')
% grid minor
% xlim([0,20])
% 
% subplot(1,2,2)
% plot(w_ben_avr, 'LineWidth',2)
% hold on
% plot(w_gngd_avr,':', 'LineWidth',2)
% xlabel('Sample')
% ylabel('Weight Error')
% title('Steady State Weight Error Approximation of Benveniste and GNGD Algorithms')
% legend('Benveniste','GNGD')
% grid minor
% xlim([200,1000])


