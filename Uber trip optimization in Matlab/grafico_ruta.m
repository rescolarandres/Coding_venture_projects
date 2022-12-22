function [] = grafico_ruta(ruta,matriz_datos,color)

for i=2:length(ruta)
    X= matriz_datos(ruta(i-1)+1,1);
    Y = matriz_datos(ruta(i-1)+1,2);
    U = matriz_datos(ruta(i)+1,1)-matriz_datos(ruta(i-1)+1,1);
    V = matriz_datos(ruta(i)+1,2)-matriz_datos(ruta(i-1)+1,2);
    quiver(X,Y,U,V,'off','Color',color); hold on
    text(X,Y,num2str(ruta(i-1))) %for ex: x = 3, y = 5 (scalars)
end
xlabel('x')
ylabel('y')
end
