%% setup the data
% load data from workspace
load("dataset/classifier_dataset.mat");

% configuration of the hyperparameters
rho = 0.5;
P = 0.18;

% define variables
Ntrain = size(traindataset, 1); 
D = 784;
Ntest = size(testdataset, 1);
ytrain = trainlabels;
ytest = testlabels;
Xtrain = traindataset; 
Xtest = testdataset;

% Adding bias term 
Xtrain = [Xtrain ones(Ntrain, 1)];
Xtest = [Xtest ones(Ntest, 1)];

%% solving the convex optimization problem
cvx_begin quiet
    variable w(D+1)  
     minimize(1/Ntrain * sum(max(0, 1 - (ytrain .* (Xtrain * w) - P * abs(ytrain)*abs(w(1:D)')*ones(D,1)))) + rho * square_pos(norm(w(1:D))));  
cvx_end

%% Attacking
%attack the dataset
Xtest_attack = testdataset;
Xtest_attack = Xtest_attack - P*sign(ytest*w(1:D)');
Xtest_attack = [Xtest_attack ones(Ntest, 1)];
%load(['Xtest_attack_' num2str(rho)]);


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
% testing on attacked data
eps = ytest .* (Xtest_attack * w);
eps(eps>0) = 0;
eps(eps<0) = 1; 
errtest_attack = 1/Ntest * sum(eps);

% return error 
fprintf('Train error [%%]: %.2f\n', errtrain * 100);
fprintf('Test error [%%]: %.2f\n', errtest * 100);
fprintf('Test error attack [%%]: %.2f\n', errtest_attack * 100);

%% save data
save(['w_robust_attack_' num2str(rho) '.mat']);



