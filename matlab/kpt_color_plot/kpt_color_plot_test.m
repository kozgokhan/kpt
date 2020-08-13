x = 0:0.1:9.5;
y = sin(x);
y_min = -1; h = 2;

kpt_color_plot(x,y,y>0.5,'c')
kpt_color_plot(x,y,y>=0 & y<=0.5,[0.5 0.5 0.5])
kpt_color_plot(x,y,y<0,'m')

plot(x,y,'o-','LineWidth',1.5);
axis([0,9.5,-1,1])