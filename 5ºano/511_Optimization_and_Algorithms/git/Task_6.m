% Task 6

% Load the training and test data
% traindataset (400x784), trainlabels (400x1)
% testdataset (1600x784), testlabels (1600x1)
load('classifier_dataset.mat'); 
%% Input Parameters
[N, D] = size(traindataset);  % N = 400, D = 784



% Define the regularization parameter ro
ro = 0.5; %used for controlling overfitting
%% CVX Section

% Solve the optimization problem using CVX
cvx_begin
    variables w(D) w0  % Classifier parameters: w (784-dimensional) and bias term intercept w0
    expression classifier_output(N) %expression that store the classifier output for all the dataset

    % Compute classifier output: this is y_n * (w_0 + x_n^T w) (lineat
    % combination of the weights with each feature vector (rows of
    % traindaset + the bias term w0)
    classifier_output = trainlabels .* (traindataset * w + w0);

    % Objective function: minimize the hinge-like loss
    % Minimize the number of misclassified points (see expression 5)
  % Objective function: minimize the hinge-like loss
% Objective function: minimize the hinge-like loss
minimize( sum(pos(1-classifier_output)) / N + ro * square_pos(norm(w,2)) )
    % minimize( sum(pos(1-classifier_output)) / N + ro * norm(w,2) ) %the pos function ensures that only points with a negative margin(misclassified) contribute to the loss, so if the point is negative(missclassified) ppos(-classifier_output) will be positive contributing to the loss
cvx_end
%This ends the CVX optimization block. After this, w and w0 will contain the optimal weights and bias learned from the training data.

%% Prediction/Evalutation section

% Evaluate on the training set
train_predictions = sign(traindataset * w + w0); %1 or -1 based on the sign of the linear comb.
train_error_rate = sum(train_predictions ~= trainlabels) / N;
%This calculates the number of misclassified points by comparing the predicted labels (train_predictions) with the actual labels (trainlabels), then computes the error rate.


% Evaluate on the test set
test_predictions = sign(testdataset * w + w0); %Predicts the labels for the test data.
test_error_rate = sum(test_predictions ~= testlabels) / size(testdataset, 1);%Computes the test error rate by comparing predicted labels with actual test labels.


%% Display section

% Display the error rates
fprintf('Training error rate: %.2f%%\n', train_error_rate * 100);
fprintf('Test error rate: %.2f%%\n', test_error_rate * 100);

% Task 6: Dopo la fine dell'ottimizzazione e calcolo di w e w0
save('task6_parameters.mat', 'w', 'w0');  % Salva i parametri w e w0 su file


%% fast check(probably correct)

N = size(traindataset,1);  % Number of rows (images) in the traindataset

figure;


for i = 1:N
    
    show_im(traindataset(i, :));  
   
    if train_predictions(i) == trainlabels(i)
        % Correct prediction (show title in green)
        title(sprintf('Correct: Image %d', i), 'Color', 'g');  
    else
        % Incorrect prediction (show title in red)
        title(sprintf('Incorrect: Image %d', i), 'Color', 'r');  
    end
    
    pause(0.1);  
end

% Function to visualize a row of traindataset as an image
function show_im(x)
    % Reshape the row vector into a 28x28 image and rescale for visualization
    image(rescale(reshape(x, 28, 28), 0, 255));
    axis square equal;  % Ensure the image is displayed as square
    colormap(gray);     % Display in grayscale
end

