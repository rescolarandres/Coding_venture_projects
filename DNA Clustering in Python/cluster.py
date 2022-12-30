import numpy as np
from Tree import Tree

def tmerge(T1, T2):
    pts = T1.root.data + ', ' + T2.root.data
    T = Tree()
    T.insert(pts)
    T.set_left(T1.root)
    T.set_right(T2.root)
    return T

def remove_rowcols(D,i,j):
    # Remove i,j rows & cols from Dij matrix, being careful that when a row/col is deleted, the indeces are no longer valid
    if i < j:
        # Remove rows
        D = np.delete(D,i,0)
        D = np.delete(D,j-1,0)
        # Remove cols
        D = np.delete(D,i,1)
        D = np.delete(D,j-1,1)
    else:
        # Remove rows
        D = np.delete(D,j,0)
        D = np.delete(D,i-1,0)
        # Remove cols
        D = np.delete(D,j,1)
        D = np.delete(D,i-1,1)
    return D   

def compute_distance_clusters(D_old,i,j):
    # This method computes an array of distances from t to each member in T.
    # The distance between clusters is the minimum distance between each of the components in the cluster
    q = []
    for col in range(D_old.shape[1]):
        if col != i and col != j:
            q.append(min(D_old[i,col],D_old[j,col]))
    # Corner element
    q.append(0)
    q = np.array(q)
    return q

def cluster(p,D):
    # List with all the lines as trees of individual lines
    T = []
    for item in p:
        tree = Tree()
        tree.insert(item)
        T.append(tree)
    
    while len(T) > 1:
        # Find indeces of minimum element in D and different than 0
        min = 1000
        for item in D:
            for dist in item:
                if dist < min and dist != 0:
                    min = dist
                    indeces = np.where(D==min)
        
        # Create a tree with the lines as children
        t = tmerge(T[indeces[0][0]],T[indeces[0][1]])
        # Remove the separated trees from the tree list, being careful with the indeces when deleting one element
        if indeces[0][0] < indeces[0][1]:
            T.remove(T[indeces[0][0]])
            T.remove(T[indeces[0][1]-1])
        else:
            T.remove(T[indeces[0][0]])
            T.remove(T[indeces[0][1]])


        # Remove rows and cols from D matrix
        D_old = D
        D = remove_rowcols(D,indeces[0][0],indeces[0][1])
        
        # Get distance array from the new tree to the others
        q = compute_distance_clusters(D_old,indeces[0][0],indeces[0][1])

        # Add the new tree to the Tree list T
        T.append(t)

        # Add q to the D matrix
        D = np.append(D,[q[:-1]],axis=0)
        D = np.append(D,np.transpose([q]),axis=1)

    return T[0]

def get_distance_matrix(lines):
    # La matriz D será del tipo numpy array para trabajar mas fácil con ella, para calcular la distancia usamos np arrays tambien para hacer la resta más facil
    D = np.zeros((len(lines),len(lines)))
    i = 0
    for row in lines.keys():
        j = 0
        for col in lines.keys():
            if row != col:
                vector = np.array(lines[row])-np.array(lines[col])
                D[i,j] = np.sqrt(vector.dot(vector))

            j +=1
        i +=1
    return D    

def navigate_tree(T,max_level,lst,current_level):
    if current_level == 0:
        current_level +=1
        lst = navigate_tree(T.root.right,max_level,lst,current_level)
        lst = navigate_tree(T.root.left,max_level,lst,current_level)
    else:

        if current_level == max_level or (T.right==None and T.left == None):
            lst.append([T.data])
            return lst
        else:
            current_level +=1
            lst = navigate_tree(T.right,max_level,lst,current_level)
            lst = navigate_tree(T.left,max_level,lst,current_level)

    return lst

def genegroup(filename):
    # Read the .dat file and store data in a dictionary
    lines = {}
    with open(filename) as file:
        for line in file:
            line = line.split(",")
            lines[line[0]] = [float(ex) for ex in line[1:-1]]

    # Calculamos la matriz D con las distancias euclideas entre lines, para ello hacemos un bucle nesteado
    D = get_distance_matrix(lines)
    # Create a list with they keys of the lines dictionary
    p = [gene for gene in lines.keys()]
    T = cluster(p,D)
    
    # Hacer una lista de listas, en la que cada lista sea uno de los 4 nietos del root
    lst = []
    max_level = 2
    lst = navigate_tree(T,max_level,lst,0)
    print(lst)
    
        


# if __name__=="__main__":

#     genegroup('genes1.dat')
