close; clear all;
%% Initialization

fs = 10000;
fo = 50;
N = 1000;
phases = [0; -2/3 * pi; 2/3 * pi];
amps = [0.6,0.7,0.8];
num_amps = length(amps);
initial_phase = 0;
shift = [0,0.5*pi,0.45*pi];
n_phases = length(phases);
t = 1:N;
v_bal = zeros(n_phases,N);
v_unbal = zeros(n_phases,N);

%% Balanced System

for i = 1:n_phases
    v_bal(i,:) = cos(2*pi*(fo/fs)*t+initial_phase+phases(i)); 
end
v_orthogonal = clarke(v_bal);
balanced_system = v_orthogonal(2,:) + 1i*v_orthogonal(3,:);
rot_balanced = circularity(balanced_system);

%% Unbalanced System

for i = 1:n_phases
    v_unbal(i,:) = amps(i)*cos(2*pi*(fo/fs)*t+initial_phase+shift(i)+phases(i));
end
v_orthogonal = clarke(v_unbal);
unbalanced_system = v_orthogonal(2,:) + 1i*v_orthogonal(3,:);
rot_unbalanced = circularity(unbalanced_system);

%% Plot Graphs
figure
scatter(real(balanced_system), imag(balanced_system));
hold on
scatter(real(unbalanced_system),imag(unbalanced_system));
legend('Balanced','Unbalanced')
xlabel('Real part')
ylabel('Imaginary part')
title(sprintf('Balanced circularity = %d, Unbalanced circularity = %d',rot_balanced,rot_unbalanced))

