%clear;clc;close all;
%% Random Signal
L = 100;
fs = 1;
steps = L-1;
% sampling time
t = (0: L - 1) / fs;
fSine = [0.1, 0.27];
x = 2*rand(L,1)-1;
lag = linspace(0,99,100);
%% Impulse Signal
wave = [1, zeros(1, L - 1)];

%% Autocovariance and Power Spectral Density (normal)
r = xcorr(wave, 'biased');
f1 = lag ./ (2 * L) * fs;
P1 = real(fftshift(fft(ifftshift(r))));
P1 = P1(L:(2*L)-1);
r = r(L:(2*L)-1);
P2 = abs(fft(wave)) .^ 2 / L;
P2 = P2(51:100);
f2 = (0: length(P2)- 1) * (fs / ((length(P2)-1)*2));
figure
subplot(2,1,1)
plot(lag,r,'LineWidth', 2)
grid minor
title('ACF of Random Uniform 0 Mean Signal');
xlabel('Sample');
ylabel('Correlation');

subplot(2,1,2)
plot(f1,P1,'LineWidth', 2)
grid minor
title('PSD of Random Uniform 0 Mean Signal');
xlabel('Normalized Frequency (cycles/sample)');
ylabel('Power Density');
hold on
plot(f2,P2,'--','LineWidth', 2)
legend('DTFT of ACF', 'Average power across frequencies')
