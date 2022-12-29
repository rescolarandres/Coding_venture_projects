function [] = wave_front(c,t,p0)
% Create grid
x = [-0.002:5e-5:0.002]; y=[0:5e-5:0.004];
t1 = [0:1e-8:4e-6];
[G] = comp_Gaussian_tone_burst(10e6,50e-9,[-4*50e-9:10e-9:4*50e-9]);

% Create line source
source=zeros(0.0005/(5e-5),3);
source_x = [-0.0005:5e-5:0.0005];
for i=1:length(source_x)
    source(i,1)=source_x(i);
    source(i,2)=0;
    source(i,3)=0;
end


% Loop through the mesh
for i=1:length(y)
    for j=1:length(x)
        [p(i,j)] = comp_press_field_point_source(c,source,[x(j) y(i) 0],p0,t);
        [p1] = comp_press_field_point_source(c,source,[x(j) y(i) 0],1,t1);
        s1 = conv(p1,G);
        t2 = linspace(0,3e-6,length(s1));
        [~,idx] = min(abs(t2-t));
        s(i,j) = s1(idx);
    end
end

figure()
imagesc(x,y,s); colormap("autumn"); axis equal; colorbar; xlim([-0.002 0.002]);ylim([0 0.004]);
xlabel('x[m]');ylabel('y[m]'); title('Pressure field at t=1 $\mu$s','Interpreter','latex')
end