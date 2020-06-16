clear; close all;
%% Initalization

N = 1500;
var = 0.05;
fs = 1500;
noise = sqrt(var/2)*(randn(1, N) + 1i * randn(1, N));
freq_func = @(n) ((1 <= n) & (n <= 500)) .* 100 + ((501 <= n) & (n <= 1000)) .* (100 + (n - 500) / 2) + ((1001 <= n) & (n <= 1500)) .* (100 + ((n - 1000) / 25) .^ 2);
freqs = freq_func(1:N);
phases = cumsum(freqs);
y = exp( 1i * ( phases.*( (2*pi)/fs ) )) + noise;

step = 1;
leaks = [0,0.1];
n_leaks = length(leaks);
psd = cell(n_leaks,1);

c = (exp((1i * 2 * pi * (1:N) .* (0:N-1))/N));
x = (1/N)*(exp((1i * 2 * pi * (1:N)' )/N * (0:N-1)));
e_clms = zeros(n_leaks,N);
pred = zeros(n_leaks,N);
%% DFT-CLMS

for i = 1:n_leaks
    [h_clms, e_clms(i,:),pred(i,:)] = dft_clms(x, y,leaks(:,i));
    psd{i} = abs(h_clms).^2;
    median_psd = 50 * median(psd{i}, 'all');
    psd{i}(psd{i} > median_psd) = median_psd;
end
% figure
% subplot(2,1,1)
% plot(abs(pred(1,:)))
% hold on
% plot(abs(pred(2,:)))
% subplot(2,1,2)
% plot(pow2db(abs(e_clms(1,:))))
% hold on 
% plot(pow2db(abs(e_clms(2,:))),'--')

%% Plot Graphs

figure;
for i = 1:n_leaks
    subplot(1,n_leaks,i)
    mesh(psd{i});
    view(2);
    cbar = colorbar;
    cbar.Label.String = 'PSD (dB)';
    title(sprintf('Spectrogram of DFT-CLMS Estimated FM Signal, Leak = %d',leaks(i)));
    xlabel('Sample');
    ylabel('Frequency (Hz)');
    ylim([0,600])
end