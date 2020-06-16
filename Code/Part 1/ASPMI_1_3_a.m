clear; close all; 
%% Initialization

fs = 1;
n = 100;
t = (0:n-1);
f = t ./ (2*n) .* fs;
f_sin = [0.1, 0.27];
noise = randn(1, n);
noisy_sin = sin(2 * pi * f_sin(1) * t) + sin(2 * pi * f_sin(2) * t) + randn(1, n);
filtered_noise = filter([1 1], 1, noise);
signals = {noise, filtered_noise, noisy_sin};
labels = ["White Gaussian Noise", "Filtered Noise", "Noisy Sinusoid"];
n_signals = length(signals);

acf_unbiased = cell(n_signals, 1);
acf_biased = cell(n_signals, 1);
psd_unbiased = cell(n_signals, 1);
psd_biased = cell(n_signals, 1);

%% Biased and unbiased ACF

for i = 1: n_signals
    acf_unbiased{i} = xcorr(signals{i}, 'unbiased');
    acf_biased{i} = xcorr(signals{i}, 'biased');
    psd_unbiased{i} = real(fftshift(fft(ifftshift(acf_unbiased{i}))));
    psd_biased{i} = real(fftshift(fft(ifftshift(acf_biased{i}))));
    
    acf_unbiased{i} = acf_unbiased{i}(n:(2*n)-1);
    acf_biased{i} = acf_biased{i}(n:(2*n)-1);
    psd_unbiased{i} = psd_unbiased{i}(n:(2*n)-1);
    psd_biased{i} = psd_biased{i}(n:(2*n)-1);
end

%% Result plot

figure;
for i = 1: n_signals
    subplot(n_signals, 1, i);
    plot(t, acf_unbiased{i}, 'LineWidth', 2);
    hold on;
    plot(t, acf_biased{i}, 'LineWidth', 2);
    grid minor
    legend('Unbiased', 'Biased');
    title(sprintf("Correlogram of %s", labels(i)));
    xlabel('Lag (sample)');
    ylabel('ACF');
end

figure;
for i = 1: n_signals
    subplot(n_signals, 1, i);
    plot(f, psd_unbiased{i}, 'LineWidth', 2);
    hold on;
    plot(f, psd_biased{i}, 'LineWidth', 2);
    grid minor
    legend('Unbiased', 'Biased');
    title(sprintf("Spectrum of %s", labels(i)));
    xlabel('Normalised frequency (cycles/sample)');
    ylabel('PSD');
end
