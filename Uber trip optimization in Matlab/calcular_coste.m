function [coste_rutas]=calcular_coste(rutas,matriz_distancias)
coste_rutas = 0;

for i=1:size(rutas,1)
    for  j=2:size(rutas,2)
    coste_rutas = coste_rutas + matriz_distancias(rutas(i,j-1)+1,rutas(i,j)+1);
    end
end


end