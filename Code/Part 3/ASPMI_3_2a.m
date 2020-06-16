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
ar_coef_est_seg = zeros(n_segs,2);
h_seg = zeros(n_segs,n_seg);
f_seg = zeros(n_segs,n_seg);
psd_seg = zeros(n_segs,n_seg);
figure
plot(abs(y))

%% AR Model

ar_coef_est = aryule(y, 1);
[h, f] = freqz(1, ar_coef_est, N, fs);
psd = abs(h) .^ 2;

for i = 1:n_segs
    ar_coef_est_seg(i,:) = aryule(y((i - 1) * n_seg + 1: i * n_seg), 1);
    [h_seg(i,:), f_seg(i,:)] = freqz(1, ar_coef_est_seg(i,:), n_seg, fs);
    psd_seg(i,:) = abs(h_seg(i,:)) .^ 2;
end

%% Plot Graphs

figure
subplot(3,1,1)
plot(freqs, 'LineWidth',2)
grid minor
title('Real Frequency Evolution of FM Signal')
xlabel('Sample')
ylabel('Frequency')
subplot(3,1,2)
plot(f,pow2db(psd), 'LineWidth',2)
grid minor
title('AR PSD of FM Signal')
xlabel('Frequency (Hz)')
ylabel('PSD (dB)')
subplot(3,1,3)
for i = 1:n_segs
    plot(f_seg(i,:),pow2db(psd_seg(i,:)), 'LineWidth',2)
    hold on
end
grid minor
title('AR PSD of FM Signal Segments')
xlabel('Frequency (Hz)')
ylabel('PSD (dB)')
legend('Segment 1', 'Segment 2', 'Segment 3')
