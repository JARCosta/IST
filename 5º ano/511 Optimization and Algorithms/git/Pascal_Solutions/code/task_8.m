%% setup the data
% load data from workspace
load("dataset/classifier_dataset.mat");

% configuration of the hyperparameters
rho = 0.1;
P = 0.18;

% load w
load(['w_' num2str(rho)]);

% define variables
Ntrain = size(traindataset, 1); D = 784;
Ntest = size(testdataset, 1);
n = D + 1;  % Corrected to D + 1
ytrain = trainlabels;
ytest = testlabels;
Xtrain = traindataset; 
Xtest_attack = testdataset;

% attack the dataset
Xtest_attack = Xtest_attack - P*sign(ytest*w(1:D)');

% adding bias term
Xtrain = [Xtrain ones(Ntrain, 1)];
Xtest_attack = [Xtest_attack ones(Ntest, 1)];


%% solving the convex optimization problem
% cvx_begin quiet
%     variable w(n)  
%     minimize(1/Ntrain * sum(max(0, 1 - ytrain .* (Xtrain * w))) + rho * square_pos(norm(w(1:D))));  
% cvx_end

%% evaluation of the performance
% testing on trainset
eps = ytrain .* (Xtrain * w);
eps(eps>0) = 0; 
eps(eps<0) = 1; 
errtrain = 1/Ntrain * sum(eps);
% testing on testset
eps = ytest .* (Xtest_attack * w);
eps(eps>0) = 0;
eps(eps<0) = 1; 
errtest = 1/Ntest * sum(eps);

% return error 
fprintf('Train error [%%]: %.2f\n', errtrain * 100);
fprintf('Test error [%%]: %.2f\n', errtest * 100);

%save(['Xtest_attack_' num2str(rho) '.mat']);



