clear all

% Load the dataset
load('classifier_dataset.mat');

% Set the parameters
rho = 0.1;  % Regularization parameter
[N, D] = size(traindataset);  % N = 400, D = 784

% Define y, X from traindataset and trainlabels
y = trainlabels;  % Labels vector (N x 1)
X = traindataset; % Feature matrix (N x D)

% Create CVX optimization problem
cvx_begin
    % Variables: w0 (scalar) and w (vector of size D)
    variables w0 w(D)
    
    % Compute predictions: X * w gives an N-dimensional vector of predictions
    predictions = X * w + w0;  % N x 1 vector of predictions
    
    % Compute the hinge loss using vectorized form
    hinge_loss = pos(1 - y .* predictions);  % Element-wise max(0, 1 - yn * (w0 + xn' * w))
    
    % Minimize the objective function
    minimize((1/N) * sum(hinge_loss) + rho * sum_square(w))
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
