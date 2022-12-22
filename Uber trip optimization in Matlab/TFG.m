%%DATOS%%
clc;clear;close all
load("R2_100.mat");
cap = 200; % cap ---> capacidad del vehículo.

%% Obtenemos la matriz distancias con el algoritmo del vecino mas cercano
[matriz_distancias,coste_dep,num_clientes]=obtener_distancias(matriz_datos);

%% Bucle para calcular el vector de costos haciendo uso de los parámetros.
[vec_ruta,vec_coste,coste_total] = algoritmo_constructivo(num_clientes,coste_dep,matriz_distancias,matriz_datos,cap);

%% Creamos la matriz con las rutas y sus respectivos costes a partir de los vectores
[matriz_ruta]=vector2matriz(vec_ruta,num_clientes);
matriz_original = matriz_ruta;
[matriz_coste]=vector2matriz(vec_coste,num_clientes);

%% Iteramos aplicando el algoritmo de insercion/intercambio para obtener el coste minimo
error = 1;
tol = 1e-6;
coste= 1;
i=0;
coste_rutas = coste_total;
num_rutas = size(matriz_ruta,1);

 tic
while  error > tol
    yyaxis left
    plot(i,coste_rutas,'d','LineWidth',1); hold on
    ylabel('Coste ruta')
    yyaxis right
    plot(i,num_rutas,'d','LineWidth',1); hold on
    ylabel('Numero de vehiculos')
    xlabel('Iteraciones')
    
    [matriz_ruta,~,~]=intercambio_rutas(matriz_ruta,matriz_distancias,matriz_datos,cap);
    [matriz_ruta,~,~]=dosopt_rutas(matriz_ruta,matriz_distancias,matriz_datos);
    [matriz_ruta,coste_rutas,matriz_coste]=insercion_rutas(matriz_ruta,matriz_distancias,matriz_datos,cap);
    error = abs(coste_rutas-coste)/coste;
    coste = coste_rutas;
    num_rutas = size(matriz_ruta,1);
    i = i+1;

end
tiempo_ejecucion=toc;


%% Ejemplos que muestran el funcionamiento de los algoritmos
% matriz_datos = matriz_datos(1:10,:);
% [matriz_distancias,coste_dep,num_clientes]=obtener_distancias(matriz_datos);
% [vec_ruta,vec_coste,coste_total] = algoritmo_constructivo(num_clientes,coste_dep,matriz_distancias,matriz_datos,cap);
% [matriz_ruta]=vector2matriz(vec_ruta,num_clientes);
% matriz_original = matriz_ruta;
% 
% % Insercion 
% [rutas,~,~]=insercion_rutas(matriz_original,matriz_distancias,matriz_datos,cap);
% figure()
% for i=1:size(rutas,1)
%     grafico_ruta(matriz_original(i,:),matriz_datos,'b');hold on
%     grafico_ruta(rutas(i,:),matriz_datos,'r');
%     title('Cambios usando el algoritmo de insercion')
% end
% 
% % Intercambio
% [rutas,~,~]=intercambio_rutas(matriz_original,matriz_distancias,matriz_datos,cap);
% figure()
% 
% for i=1:size(rutas,1)
%     grafico_ruta(matriz_original(i,:),matriz_datos,'b');hold on
%     title('Cambios usando el algoritmo de intercambio')
%     grafico_ruta(rutas(i,:),matriz_datos,'r');
% end
% 
% % 2 Opt 
% [rutas,~,~]=dosopt_rutas(matriz_original,matriz_distancias,matriz_datos);
% figure()
% for i=1:size(rutas,1)
%     grafico_ruta(matriz_original(i,:),matriz_datos,'b');hold on
%     title('Cambios usando el algoritmo de 2 opt')
%     grafico_ruta(rutas(i,:),matriz_datos,'r');
% end
% 



%% Funciones
function [rutas,coste_nueva,matriz_coste]=insercion_rutas(rutas,matriz_distancias,matriz_datos,cap)
% Esta funcion aplica el algoritmo de insercion a la matriz de rutas
    for i=1:size(rutas,1)   % Filas a cambiar
        columna = find(any(rutas(i,:),1)); % Columnas en las que hay elementos a cambiar
        for j=1:length(columna)    % Numero de posiciones en las que podemos insertar un pasajero
            fila = find(any(rutas,2));  % Filas en las que hay elementos para insertar
            fila = fila(fila ~= i);  % Eliminamos la fila en la que insertamos
            for k= 1:length(fila)
                columna2 = find(any(rutas(fila(k),:),1)); % Columnas en las que hay elementos a insertar
                for l=1:length(columna2)  % Elementos de esas filas en los que se pueden insertar
                   coste_antigua=calcular_coste(rutas,matriz_distancias); % Calculamos el coste de la matriz rutas
                   cliente =rutas(fila(k),columna2(l)); 
                   matriz_nueva=algoritmo_insercion(rutas,cliente,i,columna(j),fila(k),columna2(l)); % Aplicamos la insercion a la matriz
                   coste_nueva = calcular_coste(matriz_nueva,matriz_distancias);
                   % Calculamos la carga del vehiculo
                   carga = 0;    
                   for m =2:length(find(matriz_nueva(i,:)~=0))+1
                        carga = carga + matriz_datos(matriz_nueva(i,m)+1,3);
                   end

                   % Calculamos las ventanas de tiempos
                   [valido] = chequear_tiempos(matriz_nueva,i,matriz_datos,matriz_distancias);
                   if coste_nueva < coste_antigua && valido == 1 && carga < cap 
                       rutas = matriz_nueva;
                        
                   end

                end
            end
        end
    end
    
    rutas = rutas(find(any(rutas,2)),:); % Borramos las filas que contengan todo 0 para eliminar vehiculos
    % Obtenemos la matriz de coste
   [matriz_coste] = getmatriz_coste(rutas,matriz_distancias);
   coste_nueva = calcular_coste(rutas,matriz_distancias);

end

function [rutas,coste_nueva,matriz_coste]=intercambio_rutas(rutas,matriz_distancias,matriz_datos,cap)
% Esta funcion aplica el algoritmo de intercambio a la matriz de rutas
    for i=1:size(rutas,1)   % Filas a cambiar
        columna = find(any(rutas(i,:),1)); % Columnas en las que hay elementos a cambiar
        for j=1:length(columna)    % Columnas en las que podemos intercambiar un pasajero: buscamos diferentes de 0 para que sea mas eficiente el codigo y no pierda tiempo
            filas = find(any(rutas,2));  % Filas en las que hay elementos para insertar
            filas = filas(filas ~= i);  % Eliminamos de la lista la fila en la que insertamos
            for k=1:length(filas)    
                columna2 = find(any(rutas(filas(k),:),1)); % Columnas en las que hay elementos a intercambiar
                for l=1:length(columna2)  % Columnas de esas filas en los que se pueden insertar
                   coste_antigua=calcular_coste(rutas,matriz_distancias); % Calculamos el coste de la matriz rutas
                   matriz_nueva=algoritmo_intercambio(rutas,i,columna(j),filas(k),columna2(l)); % Aplicamos la insercion a la matriz
                   coste_nueva = calcular_coste(matriz_nueva,matriz_distancias);
                   carga = 0; 
                   % Calculamos la carga del vehiculo
                   for m =2:length(find(matriz_nueva(i,:)~=0))+1
                        carga = carga + matriz_datos(matriz_nueva(i,m)+1,3);
                   end

                    % Calculamos las ventanas de tiempos de la filas intercambiadas
                   [valido1] = chequear_tiempos(matriz_nueva,i,matriz_datos,matriz_distancias);
                   [valido2] = chequear_tiempos(matriz_nueva,filas(k),matriz_datos,matriz_distancias);

                   if coste_nueva < coste_antigua &&   carga < cap  && valido1 == true && valido2 == true
                       rutas = matriz_nueva;
                        
                   end

                end
            end
        end
    
    end
    rutas = rutas(find(any(rutas,2)),:); % Borramos las filas que contengan todo 0 para eliminar vehiculos
   % Obtenemos la matriz de coste
    [matriz_coste] = getmatriz_coste(rutas,matriz_distancias);
    coste_nueva = calcular_coste(rutas,matriz_distancias);

end

function [rutas,coste_nueva,matriz_coste]=dosopt_rutas(rutas,matriz_distancias,matriz_datos)
    
    for i=1:size(rutas,1)   % Recorrido por filas
        columna = find(any(rutas(i,:),1));  % Elementos a cambiar en esa fila
        for j=1:length(columna)-1 % Recorrido por columnas con elementos a cambiar (al ultimo elemento no se le aplica el 2opt)
            for k=j+1:length(columna) % Recorrido por columnas con elementos a cambiar
               coste_antigua=calcular_coste(rutas,matriz_distancias); % Calculamos el coste de la matriz rutas
               [matriz_nueva]=algoritmo_2opt(rutas,columna(j),columna(k),i);
                coste_nueva = calcular_coste(matriz_nueva,matriz_distancias);
                % Calculamos las ventanas de tiempos 
                [valido] = chequear_tiempos(matriz_nueva,i,matriz_datos,matriz_distancias);
               if coste_nueva < coste_antigua && valido == true
                   rutas = matriz_nueva;
               end

            end
        end

    end
    rutas = rutas(find(any(rutas,2)),:); % Borramos las filas que contengan todo 0 para eliminar vehiculos
    % Obtenemos la matriz de coste
    [matriz_coste] = getmatriz_coste(rutas,matriz_distancias);
    coste_nueva = calcular_coste(rutas,matriz_distancias);

end



        












