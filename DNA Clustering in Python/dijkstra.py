#############################################################################
#
#  Project: Auxiliary code for the ALGED labs
#  File:    dijkstra.py
#  Rev.     1.1
#  Date:    11/20/2022
#
#  This is the auxiliaty code for the implementation of the Dijkstra
#  algorithm.
#   Based on https://joshuacclark.medium.com/dijkstras-algorithm-with-adjacency-lists-ae2e9301d315
#            https://www.udacity.com/blog/2021/10/implementing-dijkstras-algorithm-in-python.html
#            https://stackabuse.com/courses/graphs-in-python-theory-and-implementation/lessons/dijkstras-algorithm/
#
#  The parts where you are supposed to intervene are marked as
#  TO-DO. The auxiliary functions that you might (and probably will)
#  need should be placed in the marked area. The rest will stay as it
#  is, but we urge you to have a look at it, as it contains useful
#  examples of programming techniques.
#
#  (C) ALGED Lecturers, 2021, 2022
#
import sys
import math


def gload(fname):
    #  Reads a graph from a file and returns an adjacency list in the
    #  format specified in the lab statement.
    f = open(fname, "r")
    lines = [l for l in f.readlines() if len(l) > 2 and l[0] != '#']  # Read and remove comment and empty lines
    for l in lines:
        q = l.find('#')                                               # remove comments at the end of the line
        if q >= 0:
            l = l[:q]
            
    g = []
    for l in lines:
        g += [eval(l)]
    return g


####################################################################
#
#  PUT YOUR AUXILIARY FUNCTIONS HERE
#

def dijkstra(g,src):
 
    unvisited_nodes = [node for node in range(len(g))]

    # Dictionary with the shortest path to each node
    path = {}

    # Dictionary with the visited nodes
    visited = {}

    # Fill the distance list with high values to be replaced later 
    max = float('inf')
    for node in unvisited_nodes:
        path[node] = max

    # Start with the source  
    path[src] = 0
    
    # Execute Dijkstra until all nodes are visited
    while len(unvisited_nodes) > 1:
        # Obtain the minimum distance node from the current node
        current_min_node = None
        for node in unvisited_nodes: # Iterate over the nodes
            if current_min_node == None:
                current_min_node = node
            elif path[node] < path[current_min_node]:
                # If the distance to the node is smaller, update it with the min distance node
                current_min_node = node
                
        # Iterate over the adjacent nodes
        adjacent_nodes = [nodes for nodes in g[current_min_node]]
        for neighbor in adjacent_nodes:
            current_value = path[current_min_node] + neighbor[1]
            if current_value < path[neighbor[0]]:
                # Add the best previous node to get to the neighbour found so far
                path[neighbor[0]] = current_value
                # Update the visited list with the visited node
                visited[neighbor[0]] = current_min_node

        # Remove the visited node from the list
        unvisited_nodes.remove(current_min_node)
    
    return visited, path
#  (End of the auxiliary function area)
####################################################################


###################################################################

def minpath(fname, src, dst):
    # First the graph is loaded
    g = gload(fname)
    best_paths = dijkstra(g,src)

    # Once the dic with the best paths is obtained, we unwrap from the destination, backwards to the source
    current = dst
    path = [dst]
    while current != src:
        current = best_paths[0][current]
        path.append(current)

    path.reverse()
    return print(path)
    
    


#
# Test script, should not be evaluated when the file is imported
#

# if __name__ == "__main__":
#     path = minpath('grafodeejemplo.dat',0,4)
