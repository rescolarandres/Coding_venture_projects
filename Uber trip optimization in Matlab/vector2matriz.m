function [mat]=vector2matriz(vec,num_clientes)
num_rutas = sum(vec(:)==0)-1; % Encontramos el numero de veces que aparece el 0
mat = zeros(num_rutas,num_clientes+2);
j = 2;
i = 1;
k = 2;
mat(:,1)=0; % Cargamos la primera columna con el deposito
while i <= num_rutas
    if vec(j) ~= 0
        mat(i,k) = vec(j);
        j = j+1;
        k = k+1;
    else
        mat(i,k) = vec(j);
        i = i+1;
        j = j+1;
        k = 2;
    end
end
end