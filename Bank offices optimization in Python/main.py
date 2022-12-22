import random
import csv


def algoritmo_constructivo(A):
   V = [0]*10 # Lista con las m posiciones de localizaciones
   P = [0,1,2,3,4,5,6,7,8,9] #Lista con los indices de los pueblos
   coste = 0
   while len(P)>0:
      p = random.choice(P)  # Tomamos un pueblo aleatorio
      L2 = []
      for i in range(0,7):
            if A[i][p] <= 50:
               L2.append(i)   # Añadimos a L2 las localizaciones 

      if len(L2) > 1:
         index = loc_menor_coste(A,L2,p)
         V[L2[index]] = 1
         coste = coste + A[L2[index]][10]
         loc = L2[index]
      else:
         V[L2[0]] = 1
         coste = coste + A[L2[0]][10]
         loc = L2[0]

      pueblos = []   # Tomamos los pueblos que estan a menas de 50 
      for i in range(0,len(A[loc])-2):
         if A[loc][i] > 50 and i in P:
            pueblos.append(i)

      P = pueblos

      

   
   return V, coste

def loc_menor_coste(A,L2,p):
   V = []
   coste = []
   for i in L2:
      coste.append(A[i][p])   # Obtenemos los costes de las loc en L2

   coste_min = min(coste)  # Sacamos el coste minimo 
   coste_min = coste.index(coste_min) # Obtenemos el indice en la lista de ese minimo
   V.append(coste_min)  # Añadimos a la lista V
   coste[coste_min] = 100 # Añadimos ese elemento de la lista para buscar el segundo de menor coste
   # Repetimos el proceso para buscaar el de segundo menor coste
   coste_min = min(coste)
   coste_min = coste.index(coste_min)
   V.append(coste_min)  # Lista con los indices de los dos menores costes
   v = random.choice(V) # Elegimos aleatoriamente entre uno de los dos

   return v



instancia1 = [
[25, 50, 37, 15, 0, 12, 9, 45, 81, 43, 30],
[41, 52, 19, 23, 42, 37, 32, 27, 125, 37, 25],
[100, 84, 75, 84, 91, 67, 49, 61, 150, 54, 40],
[19, 58, 114, 87, 37, 45, 67, 159, 47, 3, 37],
[45, 61, 87, 28, 64, 38, 59, 91, 121, 34, 29],
[17, 5, 28, 94, 62, 47, 53, 68, 42, 18, 31],
[67, 49, 61, 150, 54, 41, 52, 38, 31, 42, 38]]

instancia2 = [
[1, 17, 56, 61, 37, 78, 18, 51, 18, 78, 27, 75],
[52, 28, 63, 53, 17, 54, 38, 25, 74, 74, 54],
[38, 46, 68, 47, 72, 26, 31, 24, 75, 73, 100],
[125, 61, 35, 55, 15, 68, 53, 68, 39, 61, 21],
[49, 71, 71, 58, 75, 34, 17, 61, 41, 28, 81],
[59, 25, 75, 24, 29, 67, 56, 21, 49, 17, 90],
[68, 37, 79, 59, 37, 28, 61, 24, 62, 58, 61],
[5, 82, 8, 61, 81, 64, 38, 27, 63, 59, 39],
[71, 36, 83, 74, 49, 63, 25, 53, 17, 115, 45],
[81, 25, 49, 75, 83, 18, 68, 52, 25, 101, 29]]

instancia3 = [
[1, 49, 68, 91, 93, 101, 34, 17, 93, 41, 28, 75],
[85, 25, 95, 24, 29, 58, 57, 21, 49, 17, 54],
[91, 37, 98, 97, 37, 28, 64, 24, 65, 89, 100],
[5, 57, 8, 91, 65, 59, 38, 27, 61, 94, 21],
[98, 36, 57, 58, 49, 121, 25, 71, 17, 96, 81],
[74, 25, 49, 54, 104, 18, 74, 58, 25, 99, 90],
[75, 25, 56, 24, 29, 91, 85, 21, 49, 17, 61],
[78, 37, 52, 77, 37, 28, 91, 24, 84, 54, 39],
[5, 63, 8, 73, 64, 93, 38, 27, 83, 53, 45],
[61, 36, 105, 79, 49, 97, 25, 123, 17, 101, 29]]


# Tres soluciones factibles
for i in range(0,3):
   loc_1, coste_total_1 = algoritmo_constructivo(instancia1)
   print("Las localizaciones son")
   print(loc_1)
   print('con un coste total de ' + str(coste_total_1))


coste_opt1 = 56
coste_opt2 = 141
coste_opt3 = 114

# Primer algoritmo (algoritmo ejecutado una vez)
localizaciones_1, coste_total_1 = algoritmo_constructivo(instancia1)
localizaciones_2, coste_total_2 = algoritmo_constructivo(instancia2)
localizaciones_3, coste_total_3 = algoritmo_constructivo(instancia3)

# Segundo algoritmo (algoritmo ejecutado 5 veces y quedandonos con la mejor)
coste_total_segundo1 = 10000   
for i in range(0,4):
   loc, coste_total= algoritmo_constructivo(instancia1)
   if coste_total < coste_total_segundo1:
      coste_total_segundo1 = coste_total
      localizaciones_segundo1 = loc

coste_total_segundo2 = 10000   
for i in range(0,4):
   loc, coste_total= algoritmo_constructivo(instancia2)
   if coste_total < coste_total_segundo2:
      coste_total_segundo2 = coste_total
      localizaciones_segundo2 = loc

coste_total_segundo3 = 10000   
for i in range(0,4):
   loc, coste_total= algoritmo_constructivo(instancia3)
   if coste_total < coste_total_segundo3:
      coste_total_segundo3 = coste_total
      localizaciones_segundo3 = loc


# Hacemos la tabla (matriz) con los resultados
media_ins1 = (coste_total_1 + coste_total_segundo1)/2
media_ins2 = (coste_total_2 + coste_total_segundo2)/2
media_ins3 = (coste_total_3 + coste_total_segundo3)/2
desviacion1 = (abs(coste_total_1-media_ins1) + abs(coste_total_segundo1-media_ins1))/2
desviacion2 = (abs(coste_total_2-media_ins2) + abs(coste_total_segundo2-media_ins2))/2
desviacion3 = (abs(coste_total_3-media_ins3) + abs(coste_total_segundo3-media_ins3))/2


Tabla_resultados = [[" ", "Instancia 1", "Instancia 2", "Instancia 3"],
   ["Costes primer algoritmo",coste_total_1,coste_total_2,coste_total_3], # Primero algoritmo (fila) Instncias (columnas)
   ["Costes segundo algoritmo",coste_total_segundo1, coste_total_segundo2,coste_total_segundo3],   # Segundo algorimto (fila) Instancias (columnas)
   ["Costes optimos",coste_opt1, coste_opt2, coste_opt3],   # Costes optimos
   ["Media",media_ins1, media_ins2, media_ins3],  # Medias de costes por instancia
   ["Desviacion",desviacion1, desviacion2, desviacion3]   #Desviaciones medias
]

# Escribimos la tabla

with open('Tabla_resultados.csv', 'w') as csvfile:
    writer = csv.writer(csvfile)
    [writer.writerow(r) for r in Tabla_resultados]