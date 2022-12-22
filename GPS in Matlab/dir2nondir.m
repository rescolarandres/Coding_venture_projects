function [G_visual] = dir2nondir (G,G_visual)
indx_G = findedge(G,G_visual.Edges.EndNodes(:,1),G_visual.Edges.EndNodes(:,2));

for i=1:length(indx_G)
    if indx_G(i) == 0 || G.Edges.flux(indx_G(i)) == 0
        G_visual.Edges.flux(i) = 1;
    elseif  length(find(indx_G == indx_G(i))) > 1   % If an index is repeated, flux is twice because its bidirectional
        G_visual.Edges.flux(i) = 2*G.Edges.flux(indx_G(i));
    else
        G_visual.Edges.flux(i) = G.Edges.flux(indx_G(i));
    end
    
end