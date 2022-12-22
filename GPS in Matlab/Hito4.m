% Incremental practice for Algebra & Discrete Mathematics
% 2021-22
% 
% Name of the student: 
% Hito 4

% Maps are downloaded from: https://www.openstreetmap.org/
% Remark: To convert from .osm file to the input data, you can use the
% Python script at: https://github.com/AndG/OsmToRoadGraph

clear;clc;close all

%% Variable definition
data_dir = 'data/'; % Relative path to the data
map_filename = 'CiudadReal'; % Values: ESI, RondaCiudadReal, CiudadReal

% Set the bounds for the map (do not change)
switch map_filename
    case 'ESI'
        bounds = [-3.9272, -3.9140; 38.9871, 38.9940];
    case 'RondaCiudadReal'
        bounds = [-3.9388, -3.9136; 38.9795, 38.9965];
    case 'CiudadReal'
        bounds = [-3.9568, -3.8964; 38.9670, 39.0038];
    otherwise
        error("Wrong value for variable `map_filename`");
end


%% Load graph data
data_dir = 'C:\Users\rodri\OneDrive\Escritorio\Clases Matlab\GPS1\data\';
[n_nodes, nodes, n_edges, edges] = load_pycgr(data_dir, 'CiudadReal');


%% Construct the graph

% Compute the estimated time to drive in each edge
edges.time = edges.length*60./(0.9*edges.maxspeed*1000);

% Undirected graph for visualization
G_visual = graph(edges.source,edges.target,edges.time);
% Actual digraph
G = digraph(edges.source,edges.target,edges.time);
% Add reverse direction to bidirectional roads (from target to source)
bidirects = find(edges.bidirectional == 1); % Finds elements with bidirectional paths
G = addedge(G,edges.target(bidirects),edges.source(bidirects),edges.time(bidirects));

%% Adding data to G.Edges
indx_G = findedge(G, edges.source, edges.target);
indx_Gb = findedge(G,edges.target(bidirects), edges.source(bidirects));

G.Edges.length(indx_G) = edges.length;
G.Edges.maxspeed(indx_G) = edges.maxspeed;
G.Edges.name(indx_G) = edges.name;
G.Edges.time(indx_G) = edges.time;

G.Edges.length(indx_Gb) = edges.length(bidirects);
G.Edges.maxspeed(indx_Gb) = edges.maxspeed(bidirects);
G.Edges.name(indx_Gb) = edges.name(bidirects);
G.Edges.time(indx_Gb) = edges.time(bidirects);

%% Matrix OD
% Load the supply/demand data
data_od = xlsread("data\ODmatrix.xlsx");
% We build the matrix using a nested loop iterating within the nodes
matrix_od = zeros(size(data_od,1)); % Iitialize the matrix
D = sum(data_od(2,:));
p = cell(size(data_od,1));
for i=1:size(data_od,1) % Index i will represent rows and trip generation
    for j=1:size(data_od,1) % Index j will represent cols and trips attracted
        if i~=j  % Because intrazonal trips are not considered
            matrix_od(i,j) = data_od(i,3)*data_od(j,2)/D;
            p{i,j} = shortestpath(G,data_od(i,1),data_od(j,1),'Method','positive'); % Matrix with shortest paths of data_od edges
        end
    end
end

%% Generate flux of vehicles and transalate them to the non directed graph
% Loop to obtain the flux of each edge
for i=1:size(G.Edges,1)
G.Edges.flux(i) = flux_vehicles(matrix_od,table2array(G.Edges(i,1)),p);
end
T = sum(G.Edges.flux.*G.Edges.time);

%% Apply changes to the streets
% First change, "Calle Elisa Cendreros" and  "Calle de la Paloma" are restricted to vehicles
G1 = G; % Create another graph
edges_case1 = [find(G.Edges.name == "Calle Elisa Cendreros");find(G.Edges.name == "Calle de la Paloma") ];
G1=rmedge(G1,edges_case1);    % Delete the edges as they are forbidden to traffic
T1 = sum(G1.Edges.flux.*G1.Edges.time);

% Second change, reduce Ronda speed to 30 km/h
G2 = G;
edges_case2 = find(startsWith(G.Edges.name,"Ronda"));
G2.Edges.maxspeed(edges_case2,:) = 30;
G2.Edges.time = G2.Edges.length*60./(0.9*G2.Edges.maxspeed*1000);
T2 = sum(G2.Edges.flux.*G2.Edges.time);

% Third change, change direction of "Calle Toledo"
G3 = G; % Create another graph
edges_case3 = find(G.Edges.name == "Calle Toledo");
G3=flipedge(G3,edges_case3);    % Flip edges to turn direction
T3 = sum(G3.Edges.flux.*G3.Edges.time);

%% Generate the table with the results
Escenario = ["Caso inicial";"Escenario 1";"Escenario 2";"Escenario 3"];
T = [T;T1;T2;T3];
Tabla = table(Escenario,T)



