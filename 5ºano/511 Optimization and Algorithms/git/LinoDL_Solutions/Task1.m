%Task 1

close all
clear all

%%  Task 1. [Theoretical task] 
% Show that the function fD defined in (2) is not convex. 
% It is sufficient that you show this for the simple 
% case N = 1 and D = 1.
% Parameters

% Define the range for w0 and w
w0_values = linspace(-3, 3, 100); % Values for w0
w_values = linspace(-3, 3, 100);  % Values for w

% Create a meshgrid for w0 and w
[W0, W] = meshgrid(w0_values, w_values);

% Calculate f_D based on the conditions defined
F_D_3D = zeros(size(W0)); % Initialize f_D
F_D_3D(W0 + W < 0) = 1;   % Set f_D = 1 where w0 + w < 0
F_D_3D(W0 + W >= 0) = 0;  % Set f_D = 0 where w0 + w >= 0

% Create a 3D plot for the function f_D(w0, w)
figure;
surf(W0, W, F_D_3D, 'FaceColor', 'interp', 'EdgeColor', 'none');
colorbar; % Add a color bar
title('3D Visualization of $f_D(w_0, w)$','Interpreter', 'latex');
xlabel('$w_0$', 'Interpreter', 'latex');
ylabel('$w$', 'Interpreter', 'latex');
zlabel('$f_D(w_0, w)$', 'Interpreter', 'latex');
view(30, 30); % Set the view angle
grid on; % Turn on the grid

