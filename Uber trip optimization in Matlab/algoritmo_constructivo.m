function [vec_ruta,vec_coste,coste_total] = algoritmo_constructivo (num_clientes,coste_dep,matriz_distancias,matriz_datos,cap)
vec_clientes = zeros(1,num_clientes); %Vector que indicará si un cliente ha sido ruteado o no
vec_ruta = zeros(1,(num_clientes*2)+1); %Vector en el que se indicará el orden en el que los clientes han sido visitados
vec_coste = zeros(1,(num_clientes*2)+1); % Vector en el que se indicará el tiempo acumulado al llegar a cada cliente
Wj = zeros(1,num_clientes);
coste_total = 0; %Coste total de todas las rutas.
Carga= 0; %Carga que lleva el vehículo en este momento
posicion_ruta = 1; %Posicion en el vector ruta. Comenzamos a completar por la primera.
while(num_clientes > sum(vec_clientes)) %Mientras siga habiendo clientes por visitar el bucle seguirá corriendo.
    Carga = 0;
    [val_min,pos_val] = min(coste_dep); %Tomamos el valor minimo de los costes del vector de costes para el primer cliente.
    vec_ruta(posicion_ruta) = 0; %Iniciamos el vector ruta en el depósito (valor 8).
    vec_ruta(posicion_ruta+1) = pos_val; %Añadimos al vector ruta el cliente con el menor coste ya seleccionado anteriormente que será el primer cliente visitado.
    vec_coste (posicion_ruta) = 0;
    vec_coste (posicion_ruta+1) =matriz_datos(pos_val+1,4)+ calcular_coste(vec_ruta(posicion_ruta:posicion_ruta+1),matriz_distancias);
    
    if (matriz_datos(pos_val+1,4)) >= val_min %Comprobamos si se cumple la restricción de tiempo de la ventana de inicio de serviicio para el primer cliente.
        Wi = matriz_datos(pos_val+1,4); %Si existe espera, el inicio de la ventana será el primer momento posible de la ventana de tiempo de inicio de servicio.
    else
        Wi = val_min; %En caso contrario, se iniciará el servicio en el primer tiempo posible.
    end
    posicion_ruta = posicion_ruta + 2; %Actualizamos la posicion en el vector ruta.
    if (posicion_ruta >3 && vec_ruta(posicion_ruta-2) == 0)
        coste_total = coste_total + matriz_distancias(1,vec_ruta(posicion_ruta-3)+1) + coste_dep(pos_val)+matriz_datos(2,6); %Actualizamos coste total.
    else 
        coste_total = coste_total + coste_dep(pos_val)+matriz_datos(2,6); %Actualizamos coste total.
    end
    coste_dep(pos_val) = 999999999; %Modificamos el coste a un valor muy elevado para que no se vuelva a escoger.
    Carga = Carga + matriz_datos(pos_val+1,3); %Sumamos a la carga del vehículo la demanda correspondiente al primer cliente.
    vec_clientes(pos_val) = 1; %Actualizamos el cliente como ya visitado.
    while (Carga <= cap) %Se ejecuta el bucle mientras la carga del vehículo no supere su capacidad máxima
        funcion_costes = zeros(1,num_clientes); %Vector que guarda los costos de cada cliente desde el último cliente ruteado.
        for i = 1:num_clientes %Bucle para calcular el coste de visitar el resto de clientes desde el cliente actual.
            if (vec_clientes(i) == 0) %En caso de tomar el valor 1, el cliente ya ha sido visitado.
                if (Carga + matriz_datos(i+1,3) <= cap) %Comprobamos que en efecto el cliente se puede visitar cumpliendo la restricción de capacidad del vehículo.
                    if (Wi + matriz_datos(vec_ruta(posicion_ruta -1)+1,6) + matriz_distancias(vec_ruta(posicion_ruta-1)+1,i+1)) <= matriz_datos(i+1,5) %Comprobamos que el tiempo acumulado 
                       % más la distancia entre clientes, no sea mayor que el fin de la ventana del servicio del cliente proximo.
                       if (Wi + matriz_datos(vec_ruta(posicion_ruta -1)+1,6) + matriz_distancias(vec_ruta(posicion_ruta -1)+1,i+1)) <= matriz_datos(i+1,4) %Comprobamos si se cumple la restricción
                           % de tiempo de la ventana de inicio de serviicio para el cliente.
                           Wj(i) = matriz_datos(i+1,4); % Si existe espera, el inicio de la ventana será el primer momento posible de la ventana de tiempo de inicio de servicio.
                            
                       else 
                           Wj(i) = vec_coste(posicion_ruta-1)+matriz_datos(2,6);  % Si no, empezamos desde donde lo dejo el anterior
                       end
                       vec_ruta(posicion_ruta) = i; %Actualizamos el vector ruta con el cliente visitado.
                       vec_coste(posicion_ruta) = Wj(i);
                       funcion_costes(i) = Wj(i); %Calculamos el valor de la funcion de coste.
                       coste_total =matriz_datos(2,6)+ coste_total + matriz_distancias(vec_ruta(posicion_ruta -1)+1,i+1); %Calculamos coste total en unidades de tiempo
                       Carga = Carga + matriz_datos(i+1,3); %Actualizamos la carga del vehículo con la demanda del cliente atendido.
                       vec_clientes(i) = 1; %Actualizamos el vector cliente con el cliente ya visitado.
                       Wi = Wj(i); %Actualizamos el inicio de la ventana del cliente.
                       posicion_ruta = posicion_ruta + 1; %Nos desplazamos en el vector ruta.
                       coste_dep(i) = 999999999; %Actualizamos coste desde depósito para en caso de nueva ruta no se pueda escoger.
                    else
                        funcion_costes(i) = 999999999; %Si no se puede realizar el servicio (ventana de inicio de servicio), no se incurrirá por tanto en ningún coste.
                    end
                else
                    funcion_costes(i) = 999999999; %Si no se puede realizar el servicio (capacidad vehículo), no se incurrirá por tanto en ningún coste. 
                end
            else
                funcion_costes(i) = 999999999; %Si no se puede realizar el servicio (cliente ya visitado), no se incurrirá por tanto en ningún coste.
            end
            Wj(i) = matriz_datos(i+1,4);
        end
        if (sum(funcion_costes) > 999999998)
             Carga = cap + 1;%
             
             break %Si al finalizar, queda algún cliente que noha podido ser visitado, inciamos una nueva ruta parcial. 
        else
            [val_min,pos_val] = min(funcion_costes); %Elegimos la posición del cliente con el menor coste en la función.
            vec_ruta(posicion_ruta) = pos_val; %Actualizamos la ruta con la posición del cliente actual.
            posicion_ruta = posicion_ruta +1; %Actualizamos la posición del cliente actual.
            vec_clientes(pos_val) = 1; %Actualizamos el cliente como cliente visitado.
            coste_dep(pos_val) = 999999999; %Actualizamos el coste del cliente desde el depósito para que no se pueda volver a elegir.
            Wi = Wj(pos_val); %Actualizamos el tiempo total transcurrido.
        end
    end 
    %No se puede continuar con la ruta ya que la suma de las cargas para atender a los clientes supera la capacidad del vehículo.
end
%En caso de que no haya clientes sin visitar procedemos a crear la ruta final.
coste_total = coste_total + matriz_distancias(1,vec_ruta(posicion_ruta-1)+1);
vec_ruta(posicion_ruta) = 0;
vec_ruta = vec_ruta(1:posicion_ruta); %Eliminamos posiciones no usadas.
vec_coste = vec_coste(1:posicion_ruta); %Eliminamos posiciones no usadas.