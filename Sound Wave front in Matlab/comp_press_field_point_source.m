function [p] = comp_press_field_point_source(c,source,point,p0,t)
% Iterate to sum the contribution of all the sources
p = 0;
for i=1:length(source(:,1))
    r = norm(point-source(i,:));
    delta = double(t==round(r/c,8));    % If t=r/c delta =1
    p = p + p0*delta/(4*pi*r);
end


end

