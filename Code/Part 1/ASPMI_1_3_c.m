clear; close all; 
%% Initialisation

fs = 1;
n = 100;
t = (0:n-1);
f = t ./ (2 * n).*fs;
a_sin = [1, 0.65];
f_sin = [0.25, 0.9];

wave = a_sin(1) * sin(2 * pi * f_sin(1) * t) + a_sin(2) * sin(2 * pi * f_sin(2) * t);
n_prcs = 100;

r = zeros(n_prcs,(2*n)-1);
psd = cell(n_prcs, 1);

%% PSD 

for i = 1: n_prcs
    noisy_sin = wave + randn(size(wave));
    r(i,:) = xcorr(noisy_sin, 'biased');
    psd{i} = real(fftshift(fft(ifftshift(r(i,:)))));
    psd{i} = psd{i}(n:(2*n)-1);
end
r_clean = xcorr(wave,'biased');
psd_clean = real(fftshift(fft(ifftshift(r_clean))));
psd_clean = psd_clean(n:(2*n)-1);
psd_mean = mean(cell2mat(psd));
psd_std = std(cell2mat(psd));

%% Plot Graphs
figure;
subplot(2, 1, 1);
for i = 1: n_prcs
    indiv = plot(f,pow2db(psd{i}),'b');
    hold on;
end

mean = plot(f, pow2db(psd_mean), 'r', 'LineWidth', 2);
hold on;
clean = plot(f, pow2db(psd_clean),':g', 'LineWidth',2);

legend([indiv, mean, clean], {'Individual', 'Mean', 'Clean'});
title('Individual, Mean and Clean PSDs');
xlabel('Normalised frequency (cycles/sample)');
ylabel('PSD (dB)');
xlim([0.01,0.5])

subplot(2, 1, 2);
varPlot = plot(f, pow2db(psd_std),'LineWidth', 2);
legend('Standard Deviation');
title('Standard deviation of PSDs');
xlabel('Normalised frequency (cycles/sample)');
ylabel('PSD (dB)');
