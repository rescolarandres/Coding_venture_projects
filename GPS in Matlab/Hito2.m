% Incremental practice for Algebra & Discrete Mathematics
% 2021-22
% 
% Name of the student: 
% Hito 2

% Maps are downloaded from: https://www.openstreetmap.org/
% Remark: To convert from .osm file to the input data, you can use the
% Python script at: https://github.com/AndGem/OsmToRoadGraph

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

%% Applying Dijkstra algorithm and plotting paths
% Route 1
s1 = find(edges.source==4034); % Hospital node index
t1 = find(edges.source==3350); % ESI node index
ruta1 = shortestpath(G,edges.source(s1(1)),edges.target(t1),'Method','positive');
length1= sum(G.Edges.length(ruta1))/1000;
time1 = sum(G.Edges.time(ruta1));
fprintf('La distancia recorrida por la ruta 1 es de %f kilometros; en un tiempo de %f minutos \n',length1,time1)

figure()
show_map(axes, bounds, 'Route 1', data_dir, 'CiudadReal');hold on
plot(G_visual,'XData',nodes.lon,'YData',nodes.lat); hold on
plot(nodes.lon(ruta1),nodes.lat(ruta1),'LineWidth',1.5,'Color','b')

% Route 2
s2 = find(edges.source==4785); % ETSI
t2 = find(edges.source==4082); % Auditorio
ruta2 = shortestpath(G,edges.source(s2(1)),edges.target(t2),'Method','positive');
length2= sum(G.Edges.length(ruta2))/1000;
time2 = sum(G.Edges.time(ruta2));
fprintf('La distancia recorrida por la ruta 2 es de %f kilometros; en un tiempo de %f minutos \n',length2,time2)

figure()
show_map(axes, bounds, 'Route 2', data_dir, 'CiudadReal');hold on
plot(G_visual,'XData',nodes.lon,'YData',nodes.lat); hold on
plot(nodes.lon(ruta2),nodes.lat(ruta2),'LineWidth',1.5,'Color','b')

% Route 3
t3 = find(edges.source==4785); % ETSI
s3 = find(edges.source==4082); % Auditorio
ruta3 = shortestpath(G,edges.source(s3(1)),edges.target(t3),'Method','positive');
length3= sum(G.Edges.length(ruta3))/1000;
time3 = sum(G.Edges.time(ruta3));
fprintf('La distancia recorrida por la ruta 3 es de %f kilometros; en un tiempo de %f minutos \n',length3,time3)

figure()
show_map(axes, bounds, 'Route 3', data_dir, 'CiudadReal');hold on
plot(G_visual,'XData',nodes.lon,'YData',nodes.lat); hold on
plot(nodes.lon(ruta3),nodes.lat(ruta3),'LineWidth',1.5,'Color','b')

