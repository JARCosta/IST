function [f, gradf] = func_eval(x, y, r, s, v, u)
    
    u = [u ; 0];
    v = [v; 0];    

    % Calculate alpha
    alpha = u .* x + v;
    alpha_bar = max(alpha);

    % Calculate w_k(x_n) 
    wx_numer = exp(alpha - alpha_bar); 
    wx_denom = sum(wx_numer);       
    w_k = wx_numer / wx_denom;      

    % Calculate y_hat_k
    y_hat_k = s .* x + r;    

     % Calculate the overall y_hat(x_n)
     y_hat = sum(w_k .* y_hat_k);
        
     % Compute the error term (y_hat - y_n)
     f = y_hat - y;   
    	
    grad_r = w_k;
    grad_s = grad_r * x;
    
    grad_v = sum(-w_k .* y_hat_k * w_k', 1)' + w_k .* y_hat_k;
    grad_u = grad_v * x;

    grad_u(end) = [];
    grad_v(end) = [];

    gradf = [grad_r; grad_s; grad_v; grad_u];

end