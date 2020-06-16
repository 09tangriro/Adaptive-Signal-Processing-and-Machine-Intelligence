close; clear all;
%% Initialization

fs = 5000;
fo = 50;
N = 2000;
real_f = ones(1,N).*fo;
phases = [0; -2/3 * pi; 2/3 * pi];
amps = [0.6,0.7,0.8];
num_amps = length(amps);
initial_phase = 0;
shift = [0,0.5*pi,0.45*pi];
n_phases = length(phases);
t = 0:N-1;
v_bal = zeros(n_phases,N);
v_unbal = zeros(n_phases,N);
transient = 1;
step = 0.05;

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

%% ACLMS and CLMS
[h_bal_aclms,g_bal_aclms,~,e_bal_aclms] = aclms(balanced_system,balanced_system,step,1,1);
[h_bal_clms,~,e_bal_clms] = clms(balanced_system,balanced_system,1,step);

[h_unbal_aclms,g_unbal_aclms,~,e_unbal_aclms] = aclms(unbalanced_system,unbalanced_system,0.5,1,1);
[h_unbal_clms,~,e_unbal_clms] = clms(unbalanced_system,unbalanced_system,1,0.05);


%% Frequency Estimate
f_est_clms = -(fs/(2*pi))*atan(imag(h_bal_clms(1,:))./real(h_bal_clms(1,:)));
f_est_aclms = -(fs/(2*pi))*atan(imag(h_bal_aclms(1,:))./real(h_bal_aclms(1,:)));

f_est_clms_ = -(fs/(2*pi))*atan(imag(h_unbal_clms(1,:))./real(h_unbal_clms(1,:)));
f_est_aclms_ = abs((fs/(2*pi))*atan(sqrt(imag(h_unbal_aclms(1,:).^2 - abs(g_unbal_aclms(1,:).^2)))./real(h_unbal_aclms(1,:))));


%% Plot Graphs

figure
subplot(2,2,1)
plot(f_est_clms, 'LineWidth',2)
hold on 
plot(f_est_aclms,'--', 'LineWidth',2)
hold on 
plot(real_f,':k', 'LineWidth',2)
grid minor
legend('CLMS','ACLMS','System Frequency')
xlabel('Sample')
ylabel('Frequency (Hz)')
title('Balanced Voltage System Frequency Estimation')
subplot(2,2,2)
plot(pow2db(abs(e_bal_clms)),'LineWidth',2)
hold on
plot(pow2db(abs(e_bal_aclms)),'LineWidth',2)
grid minor
legend('CLMS', 'ACLMS')
xlabel('Sample')
ylabel('Error (dB)')
title('Balanced Voltage System Learning Curves')
subplot(2,2,3)
plot(f_est_clms_,'LineWidth',2)
hold on 
plot(f_est_aclms_,'--', 'LineWidth',2)
hold on 
plot(real_f,':k', 'LineWidth',2)
grid minor
legend('CLMS','ACLMS', 'System Frequency')
xlabel('Sample')
ylabel('Frequency (Hz)')
title('Unbalanced Voltage System Frequency Estimation')
subplot(2,2,4)
plot(pow2db(abs(e_unbal_clms)),'LineWidth',2)
hold on
plot(pow2db(abs(e_unbal_aclms)),'LineWidth',2)
grid minor
legend('CLMS', 'ACLMS')
xlabel('Sample')
ylabel('Error (dB)')
title('Unbalanced Voltage System Learning Curves')

