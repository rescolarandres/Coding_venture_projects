clc;clear;

%% Datos entrada
% Datos Malla
malla.nnd = 35; % Numero de nodos:
malla.nel = 24; % Numero de elementos:
malla.nne = 4; % Numero de nodos por elemento:
malla.nodof = 2; % Numero de grados de libertad por nodo
malla.eldof = malla.nne*malla.nodof; % Numero de grados de libertad por elemento
malla.geom = [0.00, 0.00; ... % Nodo 1
0.05, 0.0167; ... % Nodo 2
0.10, 0.0333; ... % Nodo 3
0.15, 0.0500; ... % Nodo 4
0.20, 0.0667; ... % Nodo 5
0.25, 0.0833; ... % Nodo 6
0.30, 0.10; ... % Nodo 7
0.00, 0.10; ... % Nodo 8
0.05, 0.1083; ... % Nodo 9
0.10, 0.1167; ... % Nodo 10
0.15, 0.1250; ... % Nodo 11
0.20, 0.1333; ... % Nodo 12
0.25, 0.1417; ... % Nodo 13
0.30, 0.15; ... % Nodo 14
0.00, 0.20; ... % Nodo 15
0.05, 0.20; ... % Nodo 16
0.10, 0.20; ... % Nodo 17
0.15, 0.20; ... % Nodo 18
0.20, 0.20; ... % Nodo 19
0.25, 0.20; ... % Nodo 20
0.30, 0.20; ... % Nodo 21
0.00, 0.25; ... % Nodo 22
0.05, 0.25; ... % Nodo 23
0.10, 0.25; ... % Nodo 24
0.15, 0.25; ... % Nodo 25
0.20, 0.25; ... % Nodo 26
0.25, 0.25; ... % Nodo 27
0.30, 0.25; ... % Nodo 28
0.00, 0.30; ... % Nodo 29
0.05, 0.30; ... % Nodo 30
0.10, 0.30; ... % Nodo 31
0.15, 0.30; ... % Nodo 32
0.20, 0.30; ... % Nodo 33
0.25, 0.30; ... % Nodo 34
0.30, 0.30]; ... % Nodo 35

connectivity = [1, 2, 8, 9; ... % Elemento 1
2, 3, 9, 10; ... % Elemento 2
3, 4, 10, 11; ... % Elemento 3
4, 5, 11, 12; ... % Elemento 4
5, 6, 12, 13; ... % Elemento 5
6, 7, 13, 14; ... % Elemento 6
8, 9, 15, 16; ... % Elemento 7
9, 10, 16, 17; ... % Elemento 8
10, 11, 17, 18; ... % Elemento 9
11, 12, 18, 19; ... % Elemento 10
12, 13, 19, 20; ... % Elemento 11
13, 14, 20, 21; ... % Elemento 12
15, 16, 22, 23; ... % Elemento 13
16, 17, 23, 24; ... % Elemento 14
17, 18, 24, 25; ... % Elemento 15
18, 19, 25, 26; ... % Elemento 16
19, 20, 26, 27; ... % Elemento 17
20, 21, 27, 28; ... % Elemento 18
22, 23, 29, 30; ... % Elemento 19
23, 24, 30, 31; ... % Elemento 20
24, 25, 31, 32; ... % Elemento 21
25, 26, 32, 33; ... % Elemento 22
26, 27, 33, 34; ... % Elemento 23
27, 28, 34, 35]; ... % Elemento 24

malla.connect = connectivity;
malla.connect(:,3) = connectivity(:,4);
malla.connect(:,4) = connectivity(:,3);
% Propiedades del material
prop.E = 6.9e10;    % Modulo young
prop.v = 0.33;    % Ratio poisson
prop.thick = 0.001;  % Grosor del modelo

% Condiciones contorno malla
malla.dof_fijados = [15 16 29 30 43 44 57 58];

% Matriz con las fuerzas
malla.cargas= zeros (malla.nodof*malla.nnd, 1); % Iniciar la matriz de cargas nodales a 0
%
% Cargas en x en nodos 7, 14, 21, 28 y 35
% Cargas en y en nodos 31, 32, 33, 34 y 35
%
malla.cargas(13) = -50000; % Nodo 7 en x
malla.cargas(27) = -50000; % Nodo 14 en x
malla.cargas(41) = 50000; % Nodo 21 en x
malla.cargas(55) = 50000; % Nodo 28 en x
malla.cargas(69) = 50000; % Nodo 35 en x
malla.cargas(70) = -20000; % Nodo 35 en y
malla.cargas(62) = -20000; % Nodo 31 en y
malla.cargas(64) = -20000; % Nodo 32 en y
malla.cargas(66) = -20000; % Nodo 33 en y
malla.cargas(68) = -20000; % Nodo 34 en y
malla.dee = prop.E/(1-prop.v^2)*[1 prop.v 0; prop.v 1 0;0 0 0.5*(1-prop.v)];

%% Ensamblaje Matriz rigidez
K = rigidez_elemento2(malla,prop);

%% Obtenemos los desplazamientos resolviendo el sistema
desp = zeros(malla.nodof*malla.nnd,1);
% Primero limpiamos los elementos de las condiciones de contorno ancladas en el vector fuerza y la matriz rigidez
nodos_activos = setdiff(1:malla.nodof*malla.nnd,malla.dof_fijados);

% Resolvemos el sistema de ecuaciones
desp(nodos_activos) = K(nodos_activos,nodos_activos)\malla.cargas(nodos_activos);
for i=1:malla.nnd
    geom_deformada(i,1) = malla.geom(i,1) + desp(2*i-1);
    geom_deformada(i,2) = malla.geom(i,2) + desp(2*i);
end

%% Mostramos los resultados
scatter(malla.geom(:,1), malla.geom(:,2),'b', "filled")
hold on
for i = 1: malla.nel
   plot(malla.geom(malla.connect(i,1:2),1), malla.geom(malla.connect(i,1:2),2), "b")  
   plot(malla.geom(malla.connect(i,2:3),1), malla.geom(malla.connect(i,2:3),2), "b") 
   plot(malla.geom(malla.connect(i,3:4),1), malla.geom(malla.connect(i,3:4),2), "b")
   plot(flip(malla.geom(malla.connect(i,1:3:end),1)), flip(malla.geom(malla.connect(i,1:3:end),2)), "b")
end

scatter(geom_deformada(:,1),geom_deformada(:,2),'r', "filled")
for i = 1: malla.nel
   plot(geom_deformada(malla.connect(i,1:2),1), geom_deformada(malla.connect(i,1:2),2), "r")  
   plot(geom_deformada(malla.connect(i,2:3),1), geom_deformada(malla.connect(i,2:3),2), "r") 
   plot(geom_deformada(malla.connect(i,3:4),1), geom_deformada(malla.connect(i,3:4),2), "r")
   plot(flip(geom_deformada(malla.connect(i,1:3:end),1)), flip(geom_deformada(malla.connect(i,1:3:end),2)), "r")
end


%% Funcion que calcula la rigidez del elemento

function [K] = rigidez_elemento2(malla,prop)
puntos=[ -1/sqrt(3) -1/sqrt(3); 1/sqrt(3) -1/sqrt(3); 1/sqrt(3)  1/sqrt(3);-1/sqrt(3)  1/sqrt(3)];   % Coordenadas para evaluar las derivadasa
dNdst=@(s,t) 1/4*[-(1-t), -(1-s);1-t,-(1+s); 1+t,1+s;-(1+t),1-s];   % Matriz de derivadas de la funcion de forma
k = zeros(8);
 for i=1:malla.nne
    Jacobian=malla.geom(malla.connect(1,:),:)'*dNdst(puntos(i,1),puntos(i,2)); % Calculamos el jacobiano 
    derivativesXY=dNdst(puntos(i,1),puntos(i,2))*inv(Jacobian); % Calculamos las derivadas en coordenadas absolutas
    N1_x = derivativesXY(1,1);
    N1_y = derivativesXY(1,2);
    N2_x = derivativesXY(2,1);
    N2_y = derivativesXY(2,2);
    N3_x = derivativesXY(3,1);
    N3_y = derivativesXY(3,2);
    N4_x = derivativesXY(4,1);
    N4_y = derivativesXY(4,2);
    B = [N1_x, 0, N2_x, 0, N3_x, 0, N4_x, 0;...
               0, N1_y, 0, N2_y, 0, N3_y, 0, N4_y; ...
               N1_y, N1_x, N2_y, N2_x, N3_y, N3_x, N4_y, N4_x];     % Ensamblamos la matriz de deformacion
           
    k = k + B'*malla.dee*B*det(Jacobian)*prop.thick;  % Calculamos la matriz de rigidez de cada elemento 

 end

K = zeros(malla.nodof*malla.nnd);
for i=1:malla.nel
    % Obtenemos los grados de libertad correspondientes a cada elemento
    elem_dof = [2*malla.connect(i, 1)-1; 2*malla.connect(i, 1); 2*malla.connect(i, 2)-1; 2*malla.connect(i, 2); 2*malla.connect(i, 3)-1; 2*malla.connect(i, 3); 2*malla.connect(i, 4)-1; 2*malla.connect(i, 4)];
    K(elem_dof, elem_dof) = K(elem_dof, elem_dof) + k;  % Ensamblamos la matriz de rigidez total cono la suma de la de elementos correspondientes

end
end


