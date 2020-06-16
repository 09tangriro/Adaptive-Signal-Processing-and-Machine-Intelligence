clear; close all; 
%% Initialize
load sunspot.dat

raw_data = sunspot(:,2);
n = length(raw_data);
fs = 1;
t = (0:n-1);

%% Preprocess data

data_postprocessing = detrend(raw_data - mean(raw_data));
log_data = log(raw_data+eps);
log_mean = mean(log_data);
log_data = log_data - log_mean;

%% Autocorrelation for periodicities

r = xcorr(log_data, 'biased');
r = r(288:575,1);

%% Create Periodograms

[psd_raw, ~] = periodogram(raw_data, hamming(n), n, fs);
[psd_MeanDetrend, ~] = periodogram(data_postprocessing, hamming(n), n, fs);
[psd_LogMean, f] = periodogram(log_data, hamming(n), n, fs);

%% Plot results
figure
subplot(2,1,1)
plot(raw_data,'LineWidth',2)
hold on
plot(data_postprocessing, '--' ,'LineWidth',2)
hold on
plot(log_data,'LineWidth',2)
hold on
grid minor
legend('Raw', 'Mean-detrend', 'Log-mean');
title('Raw and Processed Plots of the Sunspot Series')
xlabel('Sample')
ylabel('Amplitude')

subplot(2,1,2)
plot(f,pow2db(psd_raw),'LineWidth',2)
hold on
plot(f,pow2db(psd_MeanDetrend),'--','LineWidth',2)
hold on
plot(f,pow2db(psd_LogMean),'LineWidth',2)
hold on
grid minor
legend('Raw', 'Mean-detrend', 'Log-mean');
title('Peridograms of Raw and Processed Sunspot Series')
xlabel('Normalized Frequency (cycles/sample)')
ylabel('PSD (dB)')


figure
subplot(2,1,1)
plot(t,r,'LineWidth',2)
grid minor
title('ACF of Log-Mean Sunspot Series')
xlabel('Sample')
ylabel('Correlation')

subplot(2,1,2)
plot(f,psd_LogMean,'LineWidth',2)
grid minor
title('Peridogram of Log-Mean Sunspot Series')
xlabel('Normalized Frequency (cycles/sample)')
ylabel('PSD')