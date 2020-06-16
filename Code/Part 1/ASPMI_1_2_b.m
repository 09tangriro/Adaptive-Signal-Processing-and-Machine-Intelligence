clear; close all;
%% Initialisation

eeg = load('EEG_Data/EEG_Data_Assignment1.mat');
fs = eeg.fs;
N = length(eeg.POz);
windows = [10,5,1];
fres = 1/5;
nfft = fs/fres;
nOverlap = 0;
poz = detrend(eeg.POz - mean(eeg.POz));
%% Standard Periodogram

[psd,f] = periodogram(poz,hamming(N),nfft,fs);
%% Welch Average Periodograms
for i = 1:length(windows)   
    nFrames = windows(i) * fs;
    psdWelch{i} = pwelch(poz,hamming(nFrames),nOverlap,nfft,fs);
end
%% Plot Graphs

figure
subplot(1,2,1)
plot(f,pow2db(psd),'LineWidth',2)
xlim([0 60])
grid minor
title('Standard Periodogram')
xlabel('Frequency (Hz)')
ylabel('PSD (dB)')
subplot(1,2,2)
plot(f,pow2db(psdWelch{1}),'LineWidth',2)
hold on
plot(f,pow2db(psdWelch{2}),'LineWidth',2)
hold on
plot(f,pow2db(psdWelch{3}),'LineWidth',2)
grid minor
legend('window=10s','window=5s','window=1s', 'Location','southwest')
title('Welch Average Periodograms')
xlabel('Frequency (Hz)')
ylabel('PSD (dB)')
xlim([0 60])