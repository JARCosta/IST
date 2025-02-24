w0 = linspace(-5,5,100);
gd = 1-w0;
gd(gd<0) = 0;
f = gd -w0.^2;

figure;
plot(w0, f);
grid on; 
%legend('$h(u)$','Interpreter','Latex');
xlabel('$w_0$','Interpreter','Latex')
ylabel('$f(w_0)$','Interpreter','Latex')