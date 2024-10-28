% Load the dataset
load('classifier_dataset.mat');

% Assign variables
X = traindataset; % N x D matrix
y = trainlabels;  % N x 1 vector
[N, D] = size(X);

% Regularization parameter
rho = 0.1;

% Perturbation constant for the adversarial attack
P = 0.18;

% Solve the optimization problem with CVX
cvx_begin
    variables w0 w(D,1)
    % Define the hinge loss with adversarial perturbation
    % hinge_loss = max(0, 1 - (y .* (w0 + X * w) - P * norm(y .* w', 1)));
    hinge_loss = max(0, 1 - (y .* (X * w) - P * abs(y)*abs(w(1:D)')*ones(D,1)));
    
    % Define the objective function (hinge loss + regularization)
    objective = (1/N) * sum(hinge_loss) + rho * square_pos(norm(w(1:D)));
    
    % Minimize the objective
    minimize(objective)
cvx_end

% Evaluate the classifier performance on training dataset
train_predictions = sign(w0 + X * w);
train_error_rate = mean(train_predictions ~= y);

% Evaluate the classifier on test dataset
test_predictions = sign(w0 + testdataset * w);
test_error_rate = mean(test_predictions ~= testlabels);

% Attack the test dataset and evaluate performance on attacked dataset
x_attacked = testdataset - P * sign(y .* w');
attacked_predictions = sign(w0 + x_attacked * w);
attacked_error_rate = mean(attacked_predictions ~= testlabels);

% Output the error rates
fprintf('Training error rate: %.2f%%\n', train_error_rate * 100);
fprintf('Test error rate: %.2f%%\n', test_error_rate * 100);
fprintf('Attacked test error rate: %.2f%%\n', attacked_error_rate * 100);
