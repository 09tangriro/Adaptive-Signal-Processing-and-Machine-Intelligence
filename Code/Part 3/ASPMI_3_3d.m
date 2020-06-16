clear; close all;
%% Initialization

eeg = load('EEG_Data/EEG_Data_Assignment1.mat');
poz = eeg.POz;
a = 23240;
poz = poz(a:a+1200-1)';
fs = eeg.fs;
N = length(poz);

leaks = [0,0.001];
n_leaks = length(leaks);
psd = cell(n_leaks,1);
x = (1/N)*(exp((1i * 2 * pi * (1:N)' )/N * (0:N-1)));

%% DFT-CLMS

for i = 1:n_leaks
    h_clms = dft_clms(x, poz,leaks(:,i));
    psd{i} = abs(h_clms).^2;
    median_psd = 50 * median(psd{i}, 'all');
    psd{i}(psd{i} > median_psd) = median_psd;
end

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
    ylim([0,60])
end


