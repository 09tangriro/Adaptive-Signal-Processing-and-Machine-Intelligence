clear; close all; 
%% Initialization

raw = load('RRI_VAIKKUN.mat');
fs = raw.fsRRI1Vaikkun;
n_signals = 3;
rri = {raw.xRRI1_Vaikkun, raw.xRRI2_Vaikkun, raw.xRRI3_Vaikkun};
nfft = 2048;
label = ["Slow", "Fast", "Normal"];
ar_coeffs = [20,30,10];
ar_coeff_labels = ["20","30","10"];
ar = cell(n_signals,1);
f_ar = cell(n_signals,1);

%% Preprocess

for i = 1:n_signals
    rri{i} = detrend(rri{i} - mean(rri{i}));
end

%% Standard Periodograms

periodograms = cell(n_signals,1);

for i = 1:n_signals
    t = length(rri{i});
    [periodograms{i},f] = periodogram(rri{i}, hamming(t), nfft, fs);
end

%% AR Process Generation
for i = 1:n_signals
    t = length(rri{i});
    [coef, var] = aryule(rri{i}, ar_coeffs(i));
    [h, f_ar{i}] = freqz(sqrt(var), coef, t, fs);
    ar{i} = abs(h) .^ 2;
end

%% Plot Graphs
figure
for i = 1:n_signals
    subplot(n_signals,1,i)
    plot(f,periodograms{i},'LineWidth',2);
    xlabel('Frequency (Hz)')
    ylabel('PSD')
    hold on
    plot(f_ar{i}, ar{i},'LineWidth',2)
    grid minor
    xlabel('Frequency (Hz)')
    ylabel('PSD')
    legend('Standard',sprintf('AR(%s)',ar_coeff_labels(i)))
    title(sprintf('Standard and Average Periodograms for %s Breathing', label(i)));
    xlim([0,0.5]);
end

