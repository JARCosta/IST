clear;

%% setup the data
% load data from workspace
load("dataset/lm_dataset_task.mat");

% initilize parameters
K = size(s,1); 
N = size(y,1);
lambda = 1; 
eps = 1e-4;
iter = 5000; %5000
cnt = 0;
save_data = 0;
 
f = 0;
gradf = 0;
for j = 1:N
    %f = f + func(x(j),y(j), r, s, v, u)^2;
    %gradf = gradf + 2*func(x(j),y(j), r, s, v, u) * grad_func(x(j), r, s, v, u);    
    [fp, gradfp] = func_eval(x(j),y(j), r, s, v, u);
    f = f + fp^2;
    gradf = gradf + 2*fp * gradfp;       
end

history.f = f;

history.gradf = norm(gradf);
history.f(end+1) = f;

%% LM algorithm 
tic
while norm(gradf) > eps & cnt < iter

    % solve optimization problem
    cvx_begin quiet
        variable x_r(K)
        variable x_s(K)
        variable x_u(K-1)
        variable x_v(K-1)
        
        var = [x_r ; x_s; x_v ; x_u];
        var_k = [r;  s;  v;  u];

        loss = 0;
        for j = 1:N
            %fp = func(x(j),y(j), r, s, v, u);
            %loss = loss + (fp + grad_func(x(j), r, s, v, u)'*(var - var_k))^2;
            [fp, gradfp] = func_eval(x(j),y(j), r, s, v, u);
            loss = loss + (fp + gradfp'*(var - var_k))^2; 
        end
        loss = loss + lambda* square_pos(norm(var-var_k));
        
        minimize(loss);
       
    cvx_end

    % evaluation function at new x value
    fnew = 0;
    gradfnew = 0;
    for j = 1:N
            %fnew = fnew + func(x(j),y(j), x_r, x_s, x_v, x_u)^2;  
            [fp, gradfp] = func_eval(x(j),y(j), x_r, x_s, x_v, x_u);
            fnew = fnew + fp^2;
            gradfnew = gradfnew + 2*fp * gradfp; 
    end

    % check update parameters
    if fnew < f 
        % update function value 
        f = fnew;
        % update parameters
        r = x_r; s = x_s; v = x_v; u = x_u;        
        % update new gradient
        gradf = gradfnew;
        
        %for j = 1:N
        %    gradf = gradf + 2*func(x(j),y(j), r, s, v, u) * grad_func(x(j), r, s, v, u);     
        %end
        % decrease step size
        
        lambda = 0.7 * lambda;        
    else
        lambda = 2 * lambda;
    end 
     % save history 
     history.f(end+1) = f; 
     history.gradf(end+1) = norm(gradf);
    cnt = cnt + 1;
    disp(['iteration: ', num2str(cnt), ', loss: ', num2str(history.f(end)), ', norm gradient: ', num2str(history.gradf(end))]);

end
 
toc

%% plot 
%load('LM_check.mat');

% plot loss
figure()
semilogy(1:size(history.f,2),history.f);
xlabel('Iterate t');
ylabel('$f(x_t)$','Interpreter','latex');
grid on;

% plot gradient
figure()
semilogy(1:size(history.gradf,2),history.gradf);
xlabel('Iterate t');
ylabel('$\| \nabla f(x_t) \|$','Interpreter','latex');
grid on;

% plot weights
xaxis = -10:10;
w = zeros(size(xaxis,2),4);
for k = 1:size(xaxis,2)
    alpha = zeros(size(s,1),1);
    %Calculate alphas  
    for i = 1:size(u,1)
        alpha(i) = u(i)*xaxis(k)+v(i);
    end
    alpha_bar = max(alpha);
    c = 0;
    % Calculate the y prediction
    for i = 1:size(s,1) 
        c = c + exp(alpha(i)-alpha_bar);
    end
    for i = 1:size(s,1) 
        w(k,i) = exp(alpha(i)-alpha_bar) /c;
    end
end

figure();
plot(xaxis,w(:,1));
hold on;
plot(xaxis,w(:,2));
plot(xaxis,w(:,3));
plot(xaxis,w(:,4));
grid on;
title('Weights');
xlabel('x');



%% debug 

uo = [-161.4; 82.9; -97.5];
vo = [-170.1; -425.9; 107.1];
so = [-3.6; -0.57; 0; -10.1];
ro = [23.5; 14.0; 34; 51.2];

    fnew = 0;
    gradfnew = 0;
    gradf = 0;
    for j = 1:N
            fnew = fnew + func(x(j),y(j), ro, so, vo, uo)^2;   
            gradfnew = gradfnew + 2*func(x(j),y(j), ro, so, vo, uo) * grad_func(x(j), ro, so, vo, uo);
            gradf = gradf + 2*func(x(j),y(j), r, s, v, u) * grad_func(x(j), r, s, v, u);
    end
fnew
norm(gradfnew)
norm(gradf)

[grad_s, grad_r, grad_u, grad_v] = calculate_gradients(x, y, so, ro, uo, vo);
grad = [grad_s ; grad_r ; grad_u ; grad_v];
norm(grad)

% plot the weights
xaxis = -10:10;
w = zeros(size(xaxis,2),4);
for k = 1:size(xaxis,2)
    alpha = zeros(size(s,1),1);
    %Calculate alphas  
    for i = 1:size(u,1)
        alpha(i) = u(i)*xaxis(k)+v(i);
    end
    alpha_bar = max(alpha);
    c = 0;
    % Calculate the y prediction
    for i = 1:size(s,1) 
        c = c + exp(alpha(i)-alpha_bar);
    end
    for i = 1:size(s,1) 
        w(k,i) = exp(alpha(i)-alpha_bar) /c;
    end
end

figure();
plot(xaxis,w(:,1));
hold on;
plot(xaxis,w(:,2));
plot(xaxis,w(:,3));
plot(xaxis,w(:,4));

% plot approximated function
ypred = zeros(N,1);
for i = 1:N
    % Calculate alpha
    alpha = [u ; 0] .* x(i) + [v; 0];
    alpha_bar = max(alpha);

    % Calculate w_k(x_n) 
    wx_numer = exp(alpha - alpha_bar); 
    wx_denom = sum(wx_numer);       
    w_k = wx_numer / wx_denom;      

    % Calculate y_hat_k
    y_hat_k = s .* x(i) + r;    

     % Calculate the overall y_hat(x_n)
     y_hat = sum(w_k .* y_hat_k);
     ypred(i) = y_hat;
end

figure();
scatter(x,y);
hold on;
plot(x,ypred);
xlabel('x');
ylabel('y');
legend('measurement $(x_n y_n)$','linear model via LM','Interpreter','Latex')
grid on;

%% save data
if save_data == 1 
    %% save data
    save('LM_task.mat','u','v','r','s','history');
end




