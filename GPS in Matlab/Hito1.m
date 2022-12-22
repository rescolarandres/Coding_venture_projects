% Incremental practice for Algebra & Discrete Mathematics
% 2021-22
% 
% Name of the student: 
% Hito 1

% Maps are downloaded from: https://www.openstreetmap.org/
% Remark: To convert from .osm file to the input data, you can use the
% Python script at: https://github.com/AndGem/OsmToRoadGraph

clear all
clc;


%% Variable definition
data_dir = 'data/'; % Relative path to the data
map_filename = 'ESI'; % Values: ESI, RondaCiudadReal, CiudadReal

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
data_dir = 'C:\Users\rodri\OneDrive\Escritorio\Clases Matlab\GPS\data\';
[n_nodes, nodes, n_edges, edges] = load_pycgr(data_dir, 'ESI');


%% Construct the graph
% Undirected graph for visualization
G_visual = graph(edges.source,edges.target);
figure()
show_map(axes, bounds, 'Undirected ESI map', data_dir, 'ESI');hold on
plot(G_visual,'XData',nodes.lon,'YData',nodes.lat)

% Actual digraph
G = digraph(edges.source,edges.target);
% Add reverse direction to bidirectional roads (from target to source)
bidirects = find(edges.bidirectional == 1); % Finds elements with bidirectional paths
G = addedge(G,edges.target(bidirects),edges.source(bidirects));


%% Plot the graph
figure()
show_map(axes, bounds, 'Directed ESI map', data_dir, 'ESI');hold on
plot(G,'XData',nodes.lon,'YData',nodes.lat)





