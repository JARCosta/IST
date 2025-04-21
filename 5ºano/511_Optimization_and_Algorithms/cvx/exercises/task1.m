clear all

fplot(@(x) 1,[-5, 0], "LineWidth",2, "Color","blue")
hold on
fplot(@(x) -1,[0,5], "LineWidth",2, "Color", "blue")
fplot(@(x) 1-x, [-5,1])
fplot(@(x) 0, [1,5])
hold off
