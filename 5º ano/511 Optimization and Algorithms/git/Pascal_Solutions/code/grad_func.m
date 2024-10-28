function res = grad_func(x, r, s, v, u)
    c = 0; 
    u = [u ; 0];
    v = [v; 0];
    grad_r = zeros(size(r));
    grad_s = zeros(size(s));
    grad_v = zeros(size(v));
    grad_u = zeros(size(u));


    alpha = zeros(size(s,1),1);
    %Calculate alphas  
    for i = 1:size(u,1)
        alpha(i) = u(i)*x+v(i);
    end
    alpha_bar = max(alpha);

    for i = 1:size(alpha,1) 
        c = c + exp(alpha(i)-alpha_bar);
    end
    
    for i = 1:size(s,1)   
    % gradient of r
    grad_r(i) = exp(alpha(i)-alpha_bar)/c;

    % gradient of s 
    grad_s(i) = grad_r(i)*x;

    % gradient of v
    for k = 1:size(s,1) 
        if k == i
            continue; 
        end
        grad_v(i) = grad_v(i) - exp(alpha(k)+alpha(i)-2*alpha_bar)*(s(k)*x+r(k));     
    end
    grad_v(i) = grad_v(i) + (exp(alpha(i)-alpha_bar) *c - exp(2*alpha(i)-2*alpha_bar)) *(s(i)*x+r(i)); 
    grad_v(i) = grad_v(i)/c^2;

    % gradient of u
    grad_u(i) = grad_v(i)*x;
    end

    % remove last element from gradient vector 
    grad_u(end) = [];
    grad_v(end) = [];

    res = [grad_r; grad_s; grad_v; grad_u];

end