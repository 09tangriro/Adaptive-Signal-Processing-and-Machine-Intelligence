close; clear all;
%% Initialization
low_wind = load('wind-dataset/low-wind.mat');
medium_wind = load('wind-dataset/medium-wind.mat');
high_wind = load('wind-dataset/high-wind.mat');

v_low = (low_wind.v_east + 1i*low_wind.v_north);
v_medium = (medium_wind.v_east + 1i*medium_wind.v_north);
v_high = (high_wind.v_east + 1i*high_wind.v_north);
winds = [v_low,v_medium,v_high]';
titles = ["Low Wind","Medium Wind","High Wind"];
w = winds(1,:);
n_winds = size(winds,1);
orders = 1:20;
n_orders = length(orders);
step = [0.1,0.01,0.001];

h_clms = cell(n_winds,n_orders);
e_clms = cell(n_winds,n_orders);
h_aclms = cell(n_winds,n_orders);
g_aclms = cell(n_winds,n_orders);
e_aclms = cell(n_winds,n_orders);

mse_clms = zeros(n_winds,n_orders);
mse_aclms = zeros(n_winds,n_orders);

%% Circularity

rot_low = circularity(v_low);
rot_medium = circularity(v_medium);
rot_high = circularity(v_high);
rots = [rot_low,rot_medium,rot_high];

%% CLMS and ACLMS
for i = 1:n_winds
    for j = 1:n_orders
        [h_clms{i,j},~,e_clms{i,j}] = clms(winds(i,:),winds(i,:),j,step(i)); 
        [h_aclms{i,j},g_aclms{i,j},~,e_aclms{i,j}] = aclms(winds(i,:),winds(i,:),step(i),j,j);
        mse_clms(i,j) = mean(abs(e_clms{i,j}) .^ 2);
        mse_aclms(i,j) = mean(abs(e_aclms{i,j}) .^ 2);
    end
    min_aclms(i) = min(mse_aclms(i,:));
    min_clms(i) = min(mse_clms(i,:));
    factor(i) = min_clms(i)/min_aclms(i);
end



%% Plot Graphs

figure
c = 1;
for i = 1:n_winds
    subplot(n_winds,2,c)
    plot(mse_aclms(i,:),'LineWidth',2) 
    hold on
    plot(mse_clms(i,:),'LineWidth',2)
    grid minor
    legend('ACLMS','CLMS')
    title(sprintf('%s Learning Curves',titles(i)))
    xlabel('Model Order')
    ylabel('MSE')
    c = c+1;
    subplot(n_winds,2,c)
    scatter(real(winds(i,:)), imag(winds(i,:)), 1)
    grid minor
    xlabel('Real part')
    ylabel('Imaginary part')
    title(sprintf('%s: Circularity = %d',titles(i),rots(i)))
    c = c+1;
end



