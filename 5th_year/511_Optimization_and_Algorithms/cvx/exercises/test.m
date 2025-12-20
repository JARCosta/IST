% firestation.m; uses package CVX from http://cvxr.com/cvx
KK = 20; % choose K = number of villages
p1 = 0.5*randn(2,KK); % generate random positions
p2 = p1+[5 ; 0]*ones(1,KK);
p = [ p1 , p2 , [ 5 ; 5 ] ]; K = size(p,2);

% plot the villages
figure(1); clf;
plot(p(1,:),p(2,:),'^','MarkerSize',8,'MarkerFaceColor','b');
grid on;

% solve the optimization problem
cvx_begin quiet
    variable x(2,1);
    
    % build cost function
    f = norm(x - p(:,1));
    for i = 2:K
        f = max(f,norm(x-p(:,i)));
    end;
    
    minimize(f);
cvx_end;

%plot solution
hold on; plot(x(1),x(2),'rx','MarkerSize',15,'LineWidth',2);