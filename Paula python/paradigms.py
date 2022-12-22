# Practica 2
import math as m
import random as rnd

## Problema 2.1

### Divide and Conquer
def maxsum_subseq_dnc(lst,main_lst):
    # This function solves the max sum of sub lists by calling itselft recursively as in a divide and conquer paradigm. In each iteration, the list will be splitted from half of the list
    # and the maximum between the left half, right half, and the crossing of the middle of the list will be taken as maximum.

    def maxsum_across(lst,mid,main_lst):
        # This function computes the maximum sum and its indeces across the mid point of the list
        # Sum from the middle to the left
        sum = 0
        left_sum = -1000
        indeces_left = []
        for i in range(mid, -1,-1):
            sum = sum + lst[i]
            
            if sum > left_sum:
                left_sum = sum
                indeces_left.append(main_lst.index(lst[i]))
                

        # Sum from the middle to the right
        sum = 0
        right_sum = -1000
        indeces_right = []
        for i in range(mid,len(lst)):
            sum = sum + lst[i]
           
            if sum > right_sum:
                right_sum = sum
                indeces_right.append(main_lst.index(lst[i]))

        # Get the maximum of either left, right or crossing the middle one
        if left_sum > right_sum and left_sum > left_sum + right_sum - lst[mid]:
            indeces = [i for i in range(min(indeces_left),max(indeces_right)+1)]
            return left_sum, indeces
        elif left_sum < right_sum and right_sum > left_sum + right_sum - lst[mid]:
            indeces = [i for i in range(min(indeces_right),max(indeces_left)+1)]
            return right_sum, indeces
        else:
            sum = left_sum + right_sum - lst[mid]
            indeces = [i for i in range(min(indeces_left),max(indeces_right)+1)]
            return sum, indeces

    
    
    if len(lst) == 0:
        # If list is empty return
        return
    elif len(lst) == 1:
        indeces = []
        # Break the recursion when only one element remains after the splits
        indeces.append(main_lst.index(lst[0]))
        return lst[0], indeces
    else:
        mid = len(lst)//2
        max_left, indeces_left = maxsum_subseq_dnc(lst[0:mid],main_lst)
        max_right, indeces_right = maxsum_subseq_dnc(lst[mid:len(lst)],main_lst)
        max_across, indeces_across = maxsum_across(lst,mid,main_lst)
        # Get the maximum of the three cases
        if max_left > max_right and max_left>max_across:
            return max_left,indeces_left
        elif max_right>max_left and max_right> max_across:
            return max_right,indeces_right
        else:
            return max_across,indeces_across


### Dynamic Programming
def maxsum_subseq_dp(lst):
    # This function will solve the max sum of sublist but storing the current maximum value and the index at which the max sub list finishes
    current_max = lst[0]
    abs_max = lst[0]
    indeces = set()

    for i in range(1,len(lst)):
        # It the current max is higher than the item itself, current max is updated, if not, the current maximum is moved to the right of the list
        if current_max + lst[i] > lst[i]:
            current_max = current_max + lst[i]
        else:
            current_max = lst[i]
        # Similarly, if the current max is higher than the absolute, the absolute is updated, and the index added to the set
        if current_max > abs_max:
            abs_max = current_max
            indeces.add(lst.index(lst[i-1]))
            indeces.add(lst.index(lst[i]))

    return abs_max,indeces
        

##Problema 2.2

class Graph:
    def __init__(self, edge_list):
        self.nverts = max(map(max, edge_list)) + 1

        self._adjacent = dict(map(lambda x: (x, set()), range(self.nverts)))
        self._color = {}
        for v_a, v_b in edge_list:
            self._adjacent[v_a].add(v_b)
            self._adjacent[v_b].add(v_a)

    def get(self, x):
        if x < self.nverts:
            return list(self._adjacent[x])
        else:
            raise AttributeError(f'Value {x} is not a vertex in this graph.')


### Greedy
def coloring_greedy(graph):
    # Firslty, the graph degree is computed. The degree of the graph is the maximum degree of its vertices
    degree = 0
    for edges in graph._adjacent.values():
        if len(edges) > degree:
            degree = len(edges)

    # The number of colors is given by k + 1, with k = sqrt(degree)
    num_colors = m.ceil(m.sqrt(degree)) + 1 
    # List with colors available (assume each number is a color)
    lst_colors = ["Color "+str(color) for color in range(num_colors)]

    # Assign first node a random color and add to the colored
    graph._color[0] = rnd.choice(lst_colors)
    lst_colored_vertices = [0]

    for node in range(1,graph.nverts):
        lst_colored_notused = lst_colors.copy()
        for adjacent in graph._adjacent[node]:
            # Remove the colors used for adjacent nodes from the notused list
            if adjacent in lst_colored_vertices and graph._color[adjacent] in lst_colored_notused:
                lst_colored_notused.remove(graph._color[adjacent])
            
        if len(lst_colored_notused) == num_colors:
            # If all the colors are available, repeat one of the used already. If not, take one from the list of available
            graph._color[node] = graph._color[rnd.choice(lst_colored_vertices)]
        else:
            graph._color[node] = rnd.choice(lst_colored_notused)
        # Add the colored vertex to the list of colored nodes
        lst_colored_vertices.append(node)

    return graph._color

    


### Backtrack
def coloring_backtrack(graph, n):
    def isValid(graph,index,lst_colored_nodes):
        for adjacent in graph._adjacent[index]:
            # If the adjacent node is colored and the color is different than verte, the color is valid
            if adjacent in lst_colored_nodes and graph._color[index] == graph._color[adjacent]:
                return False
        
        return True


    def recursive (graph,index,lst_colored_nodes,lst_colors):
        if index == len(graph._adjacent):
            # If the index is the last vertex, break the loop of the recursive
            return True

        # Assign colors to the node until one is valid
        for color in lst_colors:
            graph._color[index] = color
            lst_colored_nodes.add(index)
            # If it is valid, keep the recursion with the following indices
            if isValid(graph,index,lst_colored_nodes):
                if recursive (graph,index+1,lst_colored_nodes,lst_colors):
                    return True
                else:
                    return False
        
        # If it has tried all colors for the node and it is impossible to assign one, return False (backtrack)
        return False


    lst_colors = ["Color "+str(color) for color in range(n)]
    # Assign a color to the first node
    graph._color[0] = rnd.choice(lst_colors)
    lst_colored_nodes = {0}
    if recursive (graph,1,lst_colored_nodes,lst_colors) == False:
        # If it has gone through all combinations possible, return an empty list
        return []
    else:
        return graph._color
    

    



## Exercise 1
lst = [2,-4,1,9,-6,7,-3]
max_dnc,indeces_dnc = maxsum_subseq_dnc(lst,lst)
max_dp,indeces_dp=maxsum_subseq_dp(lst)
print('For Divide and Conquer')
print("Sum: "+ str(max_dnc)+"; Indeces: " + str(indeces_dnc))
print('For Dynamic Programming')
print("Sum: "+ str(max_dp)+"; Indeces: " + str(indeces_dp))

## Exercise 2
graph = Graph([(0, 1), (0, 4), (0, 5), (4, 5), (1, 4), (1, 3), (2, 3), (2, 4)])
graph = coloring_backtrack(graph,3)
print(graph)




