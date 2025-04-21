clear all

% Load the dataset
load('classifier_dataset.mat');

% Set the parameters
rho = 0.5;  % Regularization parameter
[N, D] = size(traindataset);  % N = 400, D = 784



% Create CVX optimization problem
cvx_begin
    % Define variables: w0 is a scalar, w is a D-dimensional vector
    variable w0
    variable w(D)
    
    % Define the objective function (vectorized form)
    objective = 0;
    for n = 1:N
        xn = traindataset(n, :)';  % nth row as column vector
        yn = trainlabels(n);
        % Add hinge loss term for each data point
        objective = objective + max(0, 1 - yn * (w0 + xn' * w));
    end
    objective = (1/N) * objective + rho * sum_square(w);  % Regularization term
    
    % Minimize the objective function
    minimize(objective)
cvx_end

% Output the optimal w0 and w
disp('Optimal w0:');
disp(w0);
disp('Optimal w:');
disp(w);

% ----- Evaluate performance on training data -----
train_predictions = traindataset * w + w0;
train_predictions(train_predictions >= 0) = 1;
train_predictions(train_predictions < 0) = -1;

% Compute training error rate
train_error_rate = sum(train_predictions ~= trainlabels) / N * 100;
fprintf('Training error rate: %.2f%%\n', train_error_rate);

% ----- Evaluate performance on test data -----
test_predictions = testdataset * w + w0;
test_predictions(test_predictions >= 0) = 1;
test_predictions(test_predictions < 0) = -1;

% Compute test error rate
test_error_rate = sum(test_predictions ~= testlabels) / length(testlabels) * 100;
fprintf('Test error rate: %.2f%%\n', test_error_rate);
