x = 1; 
y = 1; 
n = 100;
a = -10;
b = 10; 
h = (b-a)/(n-1);

[w, w0] = meshgrid(a:h:b, a:h:b);
C = sign(w0 + w*x);
f = y*C;
f(f>0) = 0;
f(f<0) = 1;





z = w0.^2 - w.^2;

% Create the 3D mesh plot
figure;
mesh(w, w0, f);

% Label axes
xlabel('$w$','Interpreter','latex');
ylabel('$w_0$','Interpreter','latex');
zlabel('$f_{D}$','Interpreter','latex');

 
