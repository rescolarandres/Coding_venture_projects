function [] = comp_press_field_plane(c,source,p0,t)
x = [-0.003:0.00001:0.003];
y = [-0.003:0.00001:0.003];
[G] = comp_Gaussian_tone_burst(10e6,50e-9,[-4*50e-9:10e-9:4*50e-9]);
t1 = [0:10e-9:3e-6];
for i=1:length(x)
    for j=1:length(y)
        [p(i,j)] = comp_press_field_point_source(c,source,[x(i) y(j) 0],p0,t);
        [p1] = comp_press_field_point_source(c,source,[x(i) y(j) 0],1,t1);
        s1 = conv(p1,G);
        t2 = linspace(0,3e-6,length(s1));
        [~,idx] = min(abs(t2-t));   % Take the index corresponding to evaluation time
        s(i,j) = s1(idx);
    end
end

figure;
subplot(2,1,1);
imagesc(x,y,p); colormap("autumn"); axis equal; xlim([-0.003 0.003]); ylim([-0.003 0.003])
colorbar
xlabel('x[m]');ylabel('y[m]'); title('Pressure field at t=1 $\mu$s','Interpreter','latex')
subplot(2,1,2);
imagesc(x,y,s); colormap("autumn"); axis equal;xlim([-0.003 0.003]); ylim([-0.003 0.003])
colorbar
xlabel('x[m]');ylabel('y[m]'); title('Pressure field at t=1 $\mu$s','Interpreter','latex')
end
