
% Load the dataset
load('classifier_dataset.mat');

% Set the parameters
rho = 0.5;  % Regularization parameter
[N, D] = size(traindataset);  % N = 400, D = 784

% Define y, X from traindataset and trainlabels
y = trainlabels;  % Labels vector (N x 1)
X = traindataset; % Feature matrix (N x D)

% Maximum perturbation P
P = 0.18;

% Function to apply optimal attack
function x_tilde = optimal_attack(x, y, w, P)
    % x is a row vector (1 x m)
    % y is a scalar (1 x 1)
    % w is a column vector (m x 1)
    % P is a scalar
    % Perform the attack
    x_tilde = x - P * sign(y * (x * w));  % Note the dot product x * w
end

% Apply the attack to all samples
X_attacked = zeros(N, D);
for i = 1:N
    X_attacked(i, :) = optimal_attack(X(i, :), y(i), w, P);
end

% Compute predictions before the attack
predictions_before = sign(w0 + X * w);

% Compute predictions after the attack
predictions_after = sign(w0 + X_attacked * w);

% Compute accuracies
accuracy_before = mean(predictions_before == y) * 100;
accuracy_after = mean(predictions_after == y) * 100;

% Display the results
fprintf('Accuracy before the attack: %.2f%%\n', accuracy_before);
fprintf('Accuracy after the attack: %.2f%%\n', accuracy_after);
