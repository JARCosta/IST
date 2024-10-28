% traindataset (400x784), trainlabels (400x1)
% testdataset (1600x784), testlabels (1600x1)
load('classifier_dataset.mat');

%% Input Parameters
[N, D] = size(traindataset); % N = 400, D = 784

ro = 0.5;


%% CVX Section
cvx_begin

variables w(D) w0
expression classifier_output(N)

classifier_output = trainlabels .* (traindataset * w + w0);
minimize( sum(pos(1-classifier_output)) / N + ro * square_pos(norm(w,2)) )

cvx_end

%% Prediction/Evalutation section
train_predictions = sign(traindataset * w + w0);
train_error_rate = sum(train_predictions ~= trainlabels) / N;

test_predictions = sign(testdataset * w + w0);
test_error_rate = sum(test_predictions ~= testlabels) / size(testdataset, 1);

%% Display section

% Display the error rates
fprintf('Training error rate: %.2f%%\n', train_error_rate * 100);
fprintf('Test error rate: %.2f%%\n', test_error_rate * 100);

save('task6_parameters.mat', 'w', 'w0');

N = size(traindataset,1);
figure;
for i = 1:N

    show_im(traindataset(i,:));

    if train_predictions(i) == trainlabels(i)
        title(sprintf('Correct: Image %d', i), 'Color', 'g');
    else
        title(sprintf('Incorrect: Image %d', i), 'Color', 'r');
    end
    pause(0.1);
end

function show_im(x)

    image(rescale(reshape(x, 28,28),0,255));
    axis square equal;
    colormap(gray);
end