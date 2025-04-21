%% setup the data
% load data from workspace
load("dataset/classifier_dataset.mat");

% define variables
Ntrain = size(traindataset, 1); D = 784;
Ntest = size(testdataset, 1);
n = D + 1;  % Corrected to D + 1
ytrain = trainlabels;
Xtrain = [traindataset ones(Ntrain, 1)];  % Adding bias term
ytest = testlabels;
Xtest = [testdataset ones(Ntest, 1)];  % Adding bias term

% configuration of the hyperparameters
rho = 0.1;

%% solving the convex optimization problem
cvx_begin quiet
    variable w(n)  
    minimize(1/Ntrain * sum(max(0, 1 - ytrain .* (Xtrain * w))) + rho * square_pos(norm(w(1:D))));  
cvx_end

%% evaluation of the performance
% testing on trainset
eps = ytrain .* (Xtrain * w);
eps(eps>0) = 0; 
eps(eps<0) = 1; 
errtrain = 1/Ntrain * sum(eps);
% testing on testset
eps = ytest .* (Xtest * w);
eps(eps>0) = 0;
eps(eps<0) = 1; 
errtest = 1/Ntest * sum(eps);

% return error 
fprintf('Train error [%%]: %.2f\n', errtrain * 100);
fprintf('Test error [%%]: %.2f\n', errtest * 100);

%% save data
%save('w_0.1.mat', 'w');



