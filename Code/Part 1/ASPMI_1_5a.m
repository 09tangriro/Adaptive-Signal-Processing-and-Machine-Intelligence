clear; close all; 
%% Initialization

raw = load('RRI_VAIKKUN.mat');
fs = raw.fsRRI1Vaikkun;
n_signals = 3;
rri = {raw.xRRI1_Vaikkun, raw.xRRI2_Vaikkun, raw.xRRI3_Vaikkun};
nfft = 2048;
windows = [50,150];
label = ["Slow", "Fast", "Normal"];
n_windows = length(windows);
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

%% Averaged Periodograms

average_periodograms = cell(n_signals,n_windows);

for i = 1:n_signals
    for j = 1:n_windows
        frames = windows(j) * fs;
        average_periodograms{i,j} = pwelch(rri{i}, hamming(frames), 0, nfft, fs);
    end
end


%% Plot Graphs
figure
for i = 1:n_signals
    subplot(n_signals,1,i)
    plot(f,periodograms{i},'LineWidth',2);
    xlabel('Frequency (Hz)')
    ylabel('PSD')
    hold on
    plot(f, average_periodograms{i,1},'LineWidth',2)
    xlabel('Frequency (Hz)')
    ylabel('PSD')
    hold on
    plot(f, average_periodograms{i,2},'LineWidth',2)
    grid minor
    xlabel('Frequency (Hz)')
    ylabel('PSD')
    legend('Standard','pwelch window=50s','pwelch window=150s')
    title(sprintf('Standard and Average Periodograms for %s Breathing', label(i)));
    xlim([0,0.5]);
end

