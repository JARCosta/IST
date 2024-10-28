clear all

% Load the dataset
load classifier_dataset.mat

% Define parameters
rho = 0.5;  % regularization parameter
[N, D] = size(traindataset);  % N = 400, D = 784

% Extract training data and labels
X_train = traindataset;  % training feature matrix (N x D)
y_train = trainlabels;   % training labels (N x 1)

% Start the CVX optimization
cvx_begin
    % Variables: w0 (scalar) and w (vector of size D)
    variables w0 w(D)


    prediction = X_train * w + w0;

    % Hinge loss function in vectorized form
    % h(y_n * (w0 + x_n^T w)) for all n
    hinge_losses = max(0, 1 - y_train .* prediction);

    % Objective function: minimize (average hinge loss + regularization)
    minimize( (1 / N) * sum(hinge_losses) + rho * square_pos(norm(w, 2)))
cvx_end

% Performance evaluation on training and test datasets

% Classifier function: C_w0,w(x) = sign(w0 + x^T w)
C = @(x) sign(w0 + x * w);

% Training set performance
train_predictions = C(X_train);
train_error_rate = sum(train_predictions ~= y_train) / N;

% Test set performance
X_test = testdataset;     % test feature matrix (1600 x 784)
y_test = testlabels;      % test labels (1600 x 1)
test_predictions = C(X_test);
test_error_rate = sum(test_predictions ~= y_test) / length(y_test);

% Display the results
fprintf('Training error rate: %.2f%%\n', train_error_rate * 100);
fprintf('Test error rate: %.2f%%\n', test_error_rate * 100);
