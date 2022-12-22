function [matriz]=algoritmo_intercambio(matriz,fila_arriba,col_arriba,fila_abajo,col_abajo)
    elemento_arriba =  matriz(fila_arriba,col_arriba);
    matriz(fila_arriba,col_arriba) = matriz(fila_abajo,col_abajo);
    matriz(fila_abajo,col_abajo) = elemento_arriba;
end