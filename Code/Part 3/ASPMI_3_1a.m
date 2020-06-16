close; clear all;
%% Initialization

N = 1000;
trials = 100;
coefs1 = 1.5+1i;
coefs2 = 2.5-0.5j;
step = 0.1;

h_clms = cell(1,trials);
e_clms = cell(1,trials);
h_aclms = cell(1,trials);
g_aclms = cell(1,trials);
e_aclms = cell(1,trials);

noise = 1 / sqrt(2) * (randn(trials,N) + 1i * randn(trials,N));
variance = mean(var(noise));
wlma = noise + coefs1 * [zeros(trials, 1), noise(:, 1: end - 1)] + coefs2 * [zeros(trials, 1), conj(noise(:, 1: end - 1))];

%% Circularity

[rotation_n, ~] = circularity(noise);
[rotation_wlma, ~] = circularity(wlma);

%% ACLMS and CLMS

for i = 1:trials
    [h_clms{i},~,e_clms{i}] = clms(wlma(i,:),noise(i,:),1,step); 
    [h_aclms{i},g_aclms{i},~,e_aclms{i}] = aclms(wlma(i,:),noise(i,:),step,1,1); 
end
e_clms_avr = mean(abs(cat(3, e_clms{:})) .^ 2, 3);
e_clms_ss = e_clms_avr(:,100:1000);
e_aclms_avr = mean(abs(cat(3, e_aclms{:})) .^ 2, 3);
e_aclms_ss = e_aclms_avr(:,100:1000);
h_clms_avr = mean(cat(3, h_clms{:}) , 3);
h_aclms_avr = mean(cat(3, h_aclms{:}) , 3);
g_aclms_avr = mean(cat(3, g_aclms{:}) , 3);
emse_aclms = mean(e_aclms_ss - var(noise(100:1000)));
emse_clms = mean(e_clms_ss - var(noise(100:1000)));


%% Plot Graphs

figure
plot(pow2db(e_aclms_avr), 'LineWidth',2)
hold on 
plot(pow2db(e_clms_avr), 'LineWidth',2)
grid minor
xlabel('Sample')
ylabel('MSE (dB)')
legend('ACLMS','CLMS')
title('MSE of ACLMS and CLMS Filters')

figure
subplot(1, 2, 1)
scatter(real(noise(:)), imag(noise(:)), 1)
legend('White noise')
title(sprintf('White noise circularity = %.2f', rotation_n))
xlabel('Real part')
ylabel('Imaginary part')
subplot(1, 2, 2)
scatter(real(wlma(:)), imag(wlma(:)), 1)
legend('WLMA(1)')
title(sprintf('WLMA(1) circularity = %.2f', rotation_wlma))
xlabel('Real part')
ylabel('Imaginary part')













