clear; close all;
%% Initialization

N = 1500;
var = 0.05;
fs = 1500;
noise = sqrt(var/2)*(randn(1, N) + 1i * randn(1, N));
freq_func = @(n) ((1 <= n) & (n <= 500)) .* 100 + ((501 <= n) & (n <= 1000)) .* (100 + (n - 500) / 2) + ((1001 <= n) & (n <= 1500)) .* (100 + ((n - 1000) / 25) .^ 2);
freqs = freq_func(1:N);
phases = cumsum(freqs);
y = exp( 1i * ( phases.*( (2*pi)/fs ) )) + noise;
n_segs = 3;
n_seg = 500;
step = 0.05;
n_steps = length(step);
c = circularity(y);

%% CLMS estimate

[h_clms, pred_clms, e_clms] = clms(y, y, 1,step);
for i = 1:N
    [h, f] = freqz(1, [1; -conj(h_clms(i))], N, fs);
    psd(:, i) = abs(h) .^ 2;
end
median_psd = 50 * median(psd, 'all');
psd(psd > median_psd) = median_psd;



%% Plot Graphs

figure;
subplot(1,2,1)
plot(freqs,'LineWidth',2)
grid minor
xlabel('Sample');
ylabel('Frequency (Hz)');
title('Real Frequency Evolution of FM Signal')
ylim([0,600])
subplot(1,2,2)
surf(1:N, f, psd, "LineStyle", "none");
view(2);
cbar = colorbar;
cbar.Label.String = 'PSD (dB)';
title('Spectrogram of CLMS Estimated FM Signal');
xlabel('Sample');
ylabel('Frequency (Hz)');
ylim([0,600])

