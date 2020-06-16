clear; close all; 
%% Initialization
fs = 1;
n_waves = 3;
noverlap = 0;

n1 = 30;
t1 = (0: n1 - 1);
f1 = t1 ./ (2 * n1) .* fs;

n2 = 51;
t2 = (0: n2 - 1);
f2 = t2 ./ (2 * n2) .* fs;

n3 = 210;
t3 = (0: n3 - 1);
f3 = t3 ./ (2 * n3) .* fs;

z1 = exp(1j*2*pi*0.3*t1)+exp(1j*2*pi*0.32*t1);
z2 = exp(1j*2*pi*0.3*t2)+exp(1j*2*pi*0.32*t2);
z3 = exp(1j*2*pi*0.3*t3)+exp(1j*2*pi*0.32*t3);
%% Periodogram Generation
psd1 = periodogram(z1,hamming(n1),n1,fs);
psd2 = periodogram(z2,hamming(n2),n2,fs);
psd3 = periodogram(z3,hamming(n3),n3,fs);

%% Plot Graphs

figure;
plot(f1,psd1,'LineWidth',2)
hold on
plot(f2,psd2,'LineWidth',2)
hold on
plot(f3,psd3,'LineWidth',2)
grid minor
xlabel('Normalised frequency (cycles/sample)')
ylabel('PSD')
title('Periodogram of Complex Exponentials')
legend('samples = 30', 'samples = 51', 'samples = 200')
xlim([0.05,0.3])

figure
subplot(3,1,1)
plot(real(z1),'LineWidth',2)
grid minor
xlabel('Sample')
ylabel('Amplitude')
title('Complex Exponential (samples = 30)')
subplot(3,1,2)
plot(t2,real(z2),'LineWidth',2)
grid minor
xlabel('Sample')
ylabel('Amplitude')
title('Complex Exponential (samples = 51)')
subplot(3,1,3)
plot(real(z3),'LineWidth',2)
grid minor
xlim([0,200])
xlabel('Sample')
ylabel('Amplitude')
title('Complex Exponential (samples = 200)')

