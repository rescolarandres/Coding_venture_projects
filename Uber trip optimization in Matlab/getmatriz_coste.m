function [matriz_coste] = getmatriz_coste(rutas,matriz_distancias)
 matriz_coste = 0*rutas;
 for i=1:size(rutas,1)
        for j=2:nnz(rutas(i,:))+1
         matriz_coste(i,j) =calcular_coste(rutas(i,1:j),matriz_distancias);
        end

 end

end