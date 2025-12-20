u = linspace(-5,5,100);
h = 1-u;
h(h<0) = 0;
step = u;
step(step>0) = 0; 
step(step<0) = 1;

figure;
plot(u, h,'DisplayName','$h(u)$');
hold on;
plot(u,step,'DisplayName','$1_R$');
grid on; 
legend('$h(u)$','$1_{R_-}$','Interpreter','Latex');
xlabel('u')
ylabel('f(u)')