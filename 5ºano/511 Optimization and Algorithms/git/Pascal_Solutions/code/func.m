function res = func(x, y, r, s, v, u)
    ypred = 0;
    c = 0; 
    
    alpha = zeros(size(s,1),1);
    %Calculate alphas  
    for i = 1:size(u,1)
        alpha(i) = u(i)*x+v(i);
    end
    alpha_bar = max(alpha);
    

    % Calculate the y prediction
    for i = 1:size(s,1) 
        c = c + exp(alpha(i)-alpha_bar);
    end
    for i = 1:size(s,1) 
        ypred = ypred + exp(alpha(i)-alpha_bar) *(s(i)*x+r(i));
    end
    
    ypred = ypred/c;
    
    % return the error of the prediction
    res = ypred - y; 
end