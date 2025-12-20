% Task 6

% Load the training and test data
% traindataset (400x784), trainlabels (400x1)
% testdataset (1600x784), testlabels (1600x1)
load('classifier_dataset.mat');
tic
%% Input Parameters
[N, D] = size(traindataset);  % N = 400, D = 784

% Define the regularization parameter ro
ro = 0.5; % Used for controlling overfitting

%% CVX Section
cvx_begin
    variables w(D) w0  % Classifier parameters: w (784-dimensional) and bias term w0
    expression classifier_output(N)  % Store classifier output for all the dataset
    
    % Compute classifier output: this is y_n * (w_0 + x_n^T w)
    classifier_output = trainlabels .* (traindataset * w + w0);
    
    % Initialize the loss function to 0
    f = 0;
    
    % Use a for loop to compute the objective function (hinge-like loss)
    for n = 1:N
        f = f + pos(1 - classifier_output(n));  % Add hinge-like loss for each sample
    end
    
    % Objective function: minimize the hinge-like loss and the regularization term
    minimize(f / N + ro * square_pos(norm(w, 2)))
cvx_end

%% Prediction/Evaluation Section

% Evaluate on the training set
train_predictions = sign(traindataset * w + w0);  % 1 or -1 based on the sign of the linear combination
train_error_rate = sum(train_predictions ~= trainlabels) / N;

% Evaluate on the test set
test_predictions = sign(testdataset * w + w0);  % Predicts the labels for the test data
test_error_rate = sum(test_predictions ~= testlabels) / size(testdataset, 1);
toc
%% Display Section

% Display the error rates
fprintf('Training error rate: %.2f%%\n', train_error_rate * 100);
fprintf('Test error rate: %.2f%%\n', test_error_rate * 100);

% Save the parameters w and w0 to a file
save('task6_parameters.mat', 'w', 'w0');

%% Fast check (visualization of predictions)

figure;

for i = 1:N
    show_im(traindataset(i, :));  % Display each image
    
    if train_predictions(i) == trainlabels(i)
        % Correct prediction (show title in green)
        title(sprintf('Correct: Image %d', i), 'Color', 'g');
    else
        % Incorrect prediction (show title in red)
        title(sprintf('Incorrect: Image %d', i), 'Color', 'r');
    end
    
    pause(0.1);  % Pause to allow visualization
end

% Function to visualize a row of traindataset as an image
function show_im(x)
    % Reshape the row vector into a 28x28 image and rescale for visualization
    image(rescale(reshape(x, 28, 28), 0, 255));
    axis square equal;  % Ensure the image is displayed as square
    colormap(gray);     % Display in grayscale
end
