clear; close all;
%% Initialization

eeg = load('EEG_Data/EEG_Data_Assignment2.mat');
poz = detrend(eeg.POz - mean(eeg.POz))';
fs = eeg.fs;
N = length(poz);
steps = [1e-2, 1e-3, 1e-4];
n_steps = length(steps);
M = [5,10,15,25];
n_orders = length(M);
nfft = 2 ^ 13;
frame = 5;
windows = 2^12;
overlaps = round(0.9 * windows);

f_sin = 50;
t = (0:N-1)/fs;
var = 0.01;
x = sin(2 * pi * f_sin * t);
s = var * randn(1, N) + x;

n_anc = cell(n_orders,n_steps);
poz_anc = cell(n_orders,n_steps);
e = cell(n_orders,n_steps);
mspe = cell(n_orders,n_steps);

%% ANC

for i = 1:n_orders
    for j = 1:n_steps
        [~,n_anc{i,j},~] = lms(s,poz,M(i),steps(j),0,1);
        poz_anc{i,j} = poz - n_anc{i,j};
        e{i,j} = (poz - poz_anc{i,j}).^2;
        mspe{i,j} = mean(e{i,j});
    end
end

%% Spectrograms

figure;
spectrogram(poz, windows, overlaps, nfft, fs, 'yaxis');
ylim([0,60])
title('Original POz Spectrogram')
count=0;
figure
for i = 1:n_orders
    for j = 1:n_steps
        count=count+1;
        subplot(n_orders,n_steps,count)
        spectrogram(poz_anc{i,j}, windows, overlaps, nfft, fs, 'yaxis');
        title(sprintf('M = %d, Step = %d',M(i),steps(j)))
        ylim([0,60])
    end
end

figure
spectrogram(poz_anc{2,2}, windows, overlaps, nfft, fs, 'yaxis');
title(sprintf('M = %d, Step = %d',10,0.001))
ylim([0,60])




