% plots_logs.m
% Read CSV data and plot 3D trajectory plus individual x,y,z and erros

clc;
clear all;
close all;

% Read the CSV data
data = readmatrix('all_logs.csv');

% Extract relevant columns
t = data(:,1);               % Time(us)
x = data(:,10);              % Drone position x
y = data(:,11);              % Drone position y
z = data(:,12);              % Drone position z
x_error = data(:,73);        % x error
y_error = data(:,74);        % y error
z_error = data(:,75);        % z error
mass_real = data(:,77);      % real mass
mass_est = data(:,78);       % estimated mass
mass_tilde = data(:,79);     % error mass

% Plot the 3D trajectory of the drone
figure (1);
plot3(x, y, z);
xlabel('X Position (m)');
ylabel('Y Position (m)');
zlabel('Z Position (m)');
grid on;
hold on;

% Plot of the positions
figure (2);
subplot(3,1,1);
plot(t, x, 'LineWidth', 1.5);
ylabel('x [m]');
grid on;
set(gca, 'FontSize', 12);

subplot(3,1,2);
plot(t, y, 'LineWidth', 1.5);
ylabel('y [m]');
grid on;
set(gca, 'FontSize', 12);

subplot(3,1,3);
plot(t, z, 'LineWidth', 1.5);
ylabel('z [m]');
xlabel('time(us)');
grid on;
set(gca, 'FontSize', 12);

% Plot the errors in position
figure(3);
subplot(3,1,1);
plot(t, x_error, 'LineWidth', 1.5);
ylabel('x error [m]');
grid on;
set(gca, 'FontSize', 12);

subplot(3,1,2);
plot(t, y_error, 'LineWidth', 1.5);
ylabel('y error [m]');
grid on;
set(gca, 'FontSize', 12);

subplot(3,1,3);
plot(t, z_error, 'LineWidth', 1.5);
ylabel('z error [m]');
xlabel('time(us)');
grid on;
set(gca, 'FontSize', 12);

% Plot the mass estimates
figure(4);
plot(t, mass_real, 'LineWidth', 1.5);
hold on;
plot(t, mass_est, 'LineWidth', 1.5);
plot(t, mass_tilde, 'LineWidth', 1.5);
hold off
ylabel('Mass (kg)');
xlabel('Time (us)');
legend('Real Mass', 'Estimated Mass', 'Error Mass');
grid on;
set(gca, 'FontSize', 12);


