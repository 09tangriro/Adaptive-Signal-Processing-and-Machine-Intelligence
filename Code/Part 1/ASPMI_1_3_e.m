clear; close all; 
%% 
n1 = 0:14;
x1 = exp(1j*2*pi*0.3*n1)+exp(1j*2*pi*0.32*n1);

n2 = 0:29;
x2 = exp(1j*2*pi*0.3*n2)+exp(1j*2*pi*0.32*n2);

n3 = 0:99;
x3 = exp(1j*2*pi*0.3*n3)+exp(1j*2*pi*0.32*n3);

signals = {x1,x2,x3};
n_sigs = length(signals);

N = [15,30,100];

trials = 100;

%% MUSIC

for i = 1:n_sigs
    for j = 1:trials
        noise = 0.2/sqrt(2)*(randn(size(signals{i}))+1j*randn(size(signals{i})));
        signal = signals{i} + noise;
        [X,R] = corrmtx(signal,14,'mod');
        [S{i,j},F{i,j}] = pmusic(R,2,[ ],1,'corr');
    end
    psd_mean{i} = mean(cell2mat(S(i,:)), 2);
    psd_std{i} = std(cell2mat(S(i,:)), [], 2);
end

%% Plot Graphs

figure
for i = 1:n_sigs
    subplot(n_sigs,1,i)
    plot(F{i,1},psd_mean{i},'linewidth',2);set(gca,'xlim',[0.25 0.40]);
    hold on
    plot(F{i,1},psd_std{i},'--','linewidth',2);set(gca,'xlim',[0.25 0.40]);
    legend('Mean','Standard Deviation')
    grid minor
    title(sprintf('MUSIC Pseudospectrum with %d samples', N(i)))
    xlabel('Frequency (Hz)')
    ylabel('Pseudospectrum')
end

