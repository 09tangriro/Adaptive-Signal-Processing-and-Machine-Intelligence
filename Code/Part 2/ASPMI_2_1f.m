clear; close all;

%% Initialization

N = 1000;
trials = 100;
ar_coeffs = [0.1,0.8];
steps = [0.05,0.01];
steps_label = ["0.05","0.01"];
num_steps = length(steps);
var = 0.25;
model = arima('AR', ar_coeffs, 'Variance', var, 'Constant', 0);
x = simulate(model,N,'NumPaths',trials)';
leaks = [0.1,0.5,0.9];
leaks_label = ["0.1","0.5","0.9"];
num_leaks = length(leaks);
w = cell(num_leaks,num_steps,trials);
w_avr = cell(num_leaks,num_steps);

%% LMS

for l = 1:num_leaks
    for i = 1:num_steps
        for j = 1:trials
            [w{l,i,j},~] = lms(x(j,:),x(j,:),length(ar_coeffs),steps(i),leaks(l),1);
        end
        w_avr{l,i} = mean(cat(3, w{l,i,:}), 3);
    end
end

%% Plot Graphs

figure
for l = 1:num_leaks
    for i = 1:num_steps
        subplot(num_leaks,1,l)
        plot(w_avr{l,i}(1,:),'LineWidth',2)
        hold on
        plot(w_avr{l,i}(2,:),'LineWidth',2)
        
    end
    grid minor
    xlabel('Sample')
    ylabel('Average Weight')
    title(sprintf('Weights for AR Coefficients leak=%s',leaks_label(l)))
    legend('a1,step=0.05','a2,step=0.05','a1,step=0.01','a2,step=0.01')
    xlim([0,1000])
    ylim([0,1])
end

% legend('a1,step=0.05','a2,step=0.05','a1,step=0.01','a2,step=0.01')


