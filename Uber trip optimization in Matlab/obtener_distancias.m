function [matriz_distancias,coste_dep,num_clientes]=obtener_distancias(matriz_datos)

num_clientes = length(matriz_datos(:,1)) - 1;%Calculamos el número de clientes en el sistema. 
matriz_distancias = zeros(num_clientes + 1);%Creamos la matriz de distancias entre clientes.
for i = 1:num_clientes + 1
    for j = 1:num_clientes + 1
        matriz_distancias(i,j) = sqrt((matriz_datos(j,1) - matriz_datos(i,1))^2 + (matriz_datos(j,2) - matriz_datos(i,2))^2);
        %Calculamos la distancia entre clientes i,j.
    end
end
coste_dep = zeros(1,num_clientes); %Vector de costes de cada cliente desde el depósito.
for i = 1:num_clientes 
    coste_dep(i) = matriz_distancias(i+1,1);
end