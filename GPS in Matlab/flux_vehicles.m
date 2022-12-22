function [f_a] = flux_vehicles(matrix_od,a,p)
% Funtion that computes the flux of an edge, where p is the path and a is
% the edge where the flux is required

f_a = 0;

for i=1:size(matrix_od,1)
    for j = 1:size(matrix_od,2)
        if i~=j
            if ismember(a,p{i,j})    % Compute delta depending on a being on the path
                delta = 1;
            else 
                delta = 0;
            end
            f_a = f_a + delta*matrix_od(i,j);
        end

    end
end


end