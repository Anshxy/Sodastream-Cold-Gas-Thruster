% Basic gas properties and initial conditions
gamma = 1.3;
R = 188.9; 
g0 = 9.81;
P_0 = 6e5; % Inlet pressure (Pa)
T_0 = 293.15;
P_atm = 101325; % Ambient pressure (Pa)

% Geometry inputs
throat_diameter = 1.5; 
diverging_angle = 5; 
converging_angle = 30; 
M_e_target = 1.8; 

% Calculate throat and exit areas
r_star = (throat_diameter / 2) / 1000;
throat_area = pi * r_star^2;

area_ratio = (1/M_e_target) * ((2/(gamma+1)) * (1 + (gamma-1)/2 * M_e_target^2))^((gamma+1)/(2*(gamma-1)));
A_e = area_ratio * throat_area;
r_e = sqrt(A_e / pi);

% Calculate theoretical performance at 6 bar
T_e = T_0 / (1 + (gamma-1)/2 * M_e_target^2);
P_e = P_0 / (1 + (gamma-1)/2 * M_e_target^2)^(gamma/(gamma-1));
v_e = M_e_target * sqrt(gamma * R * T_e);

mdot = P_0 * throat_area * sqrt(gamma/(R*T_0)) * (2/(gamma+1))^((gamma+1)/(2*(gamma-1)));
F_momentum = mdot * v_e;
F_pressure = (P_e - P_atm) * A_e;
F_total = F_momentum + F_pressure;
Isp = F_total / (mdot * g0);

% print results to command window
fprintf('\nnozzle calc results:\n')
fprintf('exit dia: %f mm\n', 2 * r_e * 1000)
fprintf('thrust = %g N\n', F_total)
fprintf('mass flow is %f g/s\n', mdot * 1000)
fprintf('isp = %f s\n\n', Isp)

% Setup geometry arrays for Mach calculation
r_inlet = 2.5 / 1000; 
L_con = (r_inlet - r_star) / tan(deg2rad(converging_angle));
L_div = (r_e - r_star) / tan(deg2rad(diverging_angle));
n_points = 500;
x_con = linspace(-L_con, 0, n_points);
x_div = linspace(0, L_div, n_points);

A_con = pi * (r_star + abs(x_con) * tan(deg2rad(converging_angle))).^2;
A_div = pi * (r_star + x_div * tan(deg2rad(diverging_angle))).^2;

% Solve for Mach number at each point
mach_func = @(M, A) (1/M) * ((2/(gamma+1)) * (1 + (gamma-1)/2 * M^2))^((gamma+1)/(2*(gamma-1))) - A/throat_area;
M_con = zeros(1, n_points);
for i = 1:n_points-1
    M_con(i) = fzero(@(M) mach_func(M, A_con(i)), [1e-5, 1]);
end
M_con(end) = 1; 

M_div = zeros(1, n_points);
M_div(1) = 1;
for i = 2:n_points
    M_div(i) = fzero(@(M) mach_func(M, A_div(i)), [1, 5]);
end

x_all = [x_con, x_div(2:end)] * 1000; 
M_all = [M_con, M_div(2:end)];

% Simulate thrust as tank pressure depletes
P0_vec = linspace(P_0, P_atm, 100); 
F_time = zeros(1, 100);

for i = 1:100
    Pe_current = P0_vec(i) / (1 + (gamma-1)/2 * M_e_target^2)^(gamma/(gamma-1));
    mdot_current = P0_vec(i) * throat_area * sqrt(gamma/(R*T_0)) * (2/(gamma+1))^((gamma+1)/(2*(gamma-1)));
    
    F_time(i) = (mdot_current * v_e) + (Pe_current - P_atm) * A_e;
    
    if F_time(i) < 0
        F_time(i) = 0; % Cap at 0 if over-expanded
    end
end

% Plotting results
figure('Color', [0.15 0.15 0.15]) % Dark grey background for visibility

subplot(2,1,1)
plot(x_all, M_all, 'c', 'LineWidth', 1.5) % Cyan line
grid on
hold on
xline(0, 'w--')
yline(1, 'w--')
title('Mach distribution', 'Color', 'w')
xlabel('Position (mm)', 'Color', 'w')
ylabel('Mach', 'Color', 'w')
set(gca, 'Color', [0.2 0.2 0.2], 'XColor', 'w', 'YColor', 'w', 'GridColor', 'w')

subplot(2,1,2)
plot(P0_vec / 100000, F_time, 'm', 'LineWidth', 1.5) % Magenta line
grid on
title('Thrust vs Tank Pressure', 'Color', 'w')
xlabel('Tank Pressure (Bar)', 'Color', 'w')
ylabel('Thrust (N)', 'Color', 'w')
set(gca, 'XDir', 'reverse', 'Color', [0.2 0.2 0.2], 'XColor', 'w', 'YColor', 'w', 'GridColor', 'w')