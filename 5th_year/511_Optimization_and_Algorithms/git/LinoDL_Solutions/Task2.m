%Task 2 (Theoretical)
clear all
close all

% MATLAB code to plot 1_R(u) and hinge loss h(u)

%% Parameters and functions
% Define the range of u values
u = linspace(-2, 2, 400);

% Define the indicator function 1_R(u)
indicator_function = @(u) (u <= 0);

% Define the hinge loss function h(u) = max(0, 1 - u)
hinge_loss_function = @(u) max(0, 1 - u);

%% Calculus section

% Compute the values for the indicator and hinge loss functions
indicator_values = arrayfun(indicator_function, u);
hinge_values = arrayfun(hinge_loss_function, u);

%% Plot section
figure;
plot(u, indicator_values, 'r--', 'LineWidth', 2);
hold on;
plot(u, hinge_values, 'b', 'LineWidth', 2);

title('Comparison of indicator function and Hinge Loss h(u)', 'FontSize', 14);
xlabel('u', 'FontSize', 12);
ylabel('Value', 'FontSize', 12);
legend('$1_{R_-}(u)$', '$h(u)$', 'Interpreter', 'latex', 'FontSize', 12);
grid minor;

% % Add x and y axis
% line([0 0], ylim, 'Color', 'black', 'LineWidth', 0.5);  % y-axis
% line(xlim, [0 0], 'Color', 'black', 'LineWidth', 0.5);  % x-axis
% 
% hold off;
