function [matriz]=algoritmo_2opt(matriz,columna1,columna2,fila)
    % Columna 1 representa el primer elemento que se va a quedar
    % fijo,mientras que columna 2 es el ultimo elemento que se va a alterar
    % Lo que se hace es invertir el orden de la ruta desde col1+1 hasta
    % col2, el resto de elementos permanecen igual
    matriz(fila,columna1+1:columna2) = flip(matriz(fila,columna1+1:columna2));

end