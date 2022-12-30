###############################################################
#
# Algoritmos y Estructura de datos 2022-23
#
# Practica: 3
# Fichero: <Tree>
# Autor: <Claudia Sanz Sainz-Rozas e Inés Cepeda Valverde>
# Fecha: <22/11/2022>
#
# <crear los metodos de base de la clase Tree para manejar arboles n>
#
###############################################################



def comp(a,b):
    lista = [a,b]
    lista_ordenada = sorted(lista)
    if a == b:
        return 0 
    if lista == lista_ordenada:
        return -1
    if lista != lista_ordenada:
        return 1

class Node:
    def __init__(self,data) :
        self.data = data
        self.right = None
        self.left = None
        
    def insert_aux(self,data,comp):
        if comp(self.data,data) == 1: 
            if self.left == None:
                self.left = Node(data)
                return
            else: 
                self.left.insert_aux(data,comp)
                
        elif comp(self.data,data) == -1:
            if self.right == None:
                self.right = Node(data)
            else:
                self.right.insert_aux(data,comp)

    def height_aux(self):
        if self.left == None:
            return 1 + self.right.height_aux()
        elif self.right == None:
            return 1 + self.left.height_aux()
        elif (self.left == None) and (self.right == None):
            return 1
        else:
            return 1 + max(self.right.height_aux(),self.left.height_aux())
        
    def in_traverse_aux(self):
        tree = []
        if self.left != None:
            tree += (self.left.in_traverse_aux())
        tree.append(self.data)
        if self.right != None:
            tree += (self.right.in_traverse_aux())
        return tree
        
    def pre_traverse_aux(self):
        tree = []
        tree.append(self.data)
        if self.left != None:
            tree += (self.left.pre_traverse_aux())
        if self.right != None:
            tree += (self.right.pre_traverse_aux())
        return tree
        
    def post_traverse_aux(self):
        tree = []
        if self.left != None:
            tree += (self.left.post_traverse_aux())
        if self.right != None:
            tree += (self.right.post_traverse_aux())
        tree.append(self.data)
        return tree
        
    def pred(self, data):
        if self.data == data:
            return True
        else:
            return False 
        
    def search_aux(self,data):
        if self.pred(data) == True:
            return True
        else:
            if self.right == None and self.left == None:
                return False
            elif self.right == None:
                return self.left.search_aux(data)
            elif self.left == None:
                return self.right.search_aux(data)
            else:
                return (self.left.seasrch_aux(data) or self.right.search_aux(data))

class Tree: 
    def __init__(self):
        self.root = None
        
    def insert(self,data):
        node = Node(data)
        if self.root == None: #arbol vacio
            self.root = node
        else: 
            self.root.insert_aux(data,comp)
    
    def set_left(self,new_node):
        self.root.left = new_node
    
    def set_right(self,new_node):
        self.root.right = new_node

    def height(self):
        if self.root == None: #arbol vacio
            return 0 #altura cero
        else: 
            return self.root.height_aux()
       
    def in_traverse(self):
        if self.root == None: #arbol vacio
            return []
        else:
            return self.root.in_traverse_aux()
    
    def pre_traverse(self):
        if self.root == None: #arbol vacio 
            return []
        else:
            return self.root.pre_traverse_aux()
        
    def post_traverse(self):
        if self.root == None: #arbol vacio
            return []
        else:
            return self.root.post_traverse_aux()
    
    def search(self,data, comp):
        if self.root == None: #arbol vacio
            return False
        else:
            return self.root.search_aux(data)
            




          

