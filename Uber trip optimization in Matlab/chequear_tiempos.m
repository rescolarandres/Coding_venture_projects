function [valido] = chequear_tiempos(matriz_nueva,fila,matriz_datos,matriz_distancias)
% Esta funcion chequea que se cumplen las ventanas de tiempo de una ruta
% (fila)

ventana_inferior =[0; matriz_datos(1+matriz_nueva(fila,find(any(matriz_nueva(fila,:),1))),4)]; % Ventana inferior de tiempos de la fila de arriba siendo cambiada                     
ventana_superior =[0; matriz_datos(1+matriz_nueva(fila,find(any(matriz_nueva(fila,:),1))),5)]; % Ventana superior de tiempos de la fila de arriba siendo cambiada 
clientes =[1 find(any(matriz_nueva(fila,:),1))];
% Calculamos los tiempos acumulados con las ventanas de tiempos y si hay tiempo de espera lo sumamos al tiempo acumulado
tiempo_acumulado = getmatriz_coste(matriz_nueva(fila,clientes),matriz_distancias) + matriz_datos(2,6)*[0 (find(any(matriz_nueva(fila,:),1))-1)];                     
for z=2:length(tiempo_acumulado)
    if tiempo_acumulado(z)<=ventana_inferior(z)
        tiempo_acumulado(z+1:end) = tiempo_acumulado(z+1:end) + ventana_inferior(z)-tiempo_acumulado(z);
        tiempo_acumulado(z) = ventana_inferior(z);
    end
end


% Chequeamos la condicion de ventanas de tiempo
if all(tiempo_acumulado'<=ventana_superior)
    valido = true;
else
    valido = false;
end



end