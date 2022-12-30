import csv

def readfiles():
	"""
	This function reads all the 12 csv files for each metro line.
	It returns a dictionary where each key is the name of the line
	and the value are a list of all the statins from that line.
	"""

	# We create an empty dictionary that will store the lines as keys,
	# and the lists of stations in that line as values.
	metro = {}

	# We notice that every csv file have the same name except for the number.
	name_files = "linea-"

	# Since we have 12 lines we iterate 12 times with range().
	for i in range(1,13):
		with open("data/" + name_files + str(i) + ".csv",encoding = "UTF-8") as file:
			reader = csv.reader(file)
			station_lines = []
			for item in reader:
				station_lines.append(item[0])

		metro[name_files + str(i)] = station_lines

	return metro

def exercise_1():
	"""
	This function returns the number of stations that exist in the Metro
	network.
	"""
	# We start by reading the csv files.
	metro = readfiles()

	# We create an empty list that will store the metro stations (without duplicates).
	unique_stations = set()

	# We iterate through the list of stations and add the ones that are not
	# in the unique_stations list.
	for line in metro.values():
		for station in line:
			unique_stations.add(station)

	# We return the length of the unique stations list (number of stations).
	return len(unique_stations)

def exercise_2():
	"""
	This function returns a list of the top 5 stations by number of lines available
	in them, sorted by which one has more lines available.
	"""

	# We start by reading the csv files.
	metro = readfiles()

	# We create an empty dictionary that will store the stations as keys and the number of
	# lines available as values.
	stations_line_count = {}

	# We create an empty list that will store the top 5 stations.
	top5 = []

	# We get a dictionary with the stations and the number of lines available.
	for line in metro.values():
		for station in line:
			if station in stations_line_count:
				stations_line_count[station] += 1
			else:
				stations_line_count[station] = 1

	# We iterate 5 times with range to find the top 5.
	for i in range(5):
		# We add the station with max value of lines to our top 5 list.
		max_value = max(stations_line_count, key=stations_line_count.get)
		top5.append(max_value)

		# We delete the station from the dictionary so it gets the next maximum.
		stations_line_count.pop(max_value)

	return top5

def exercise_3(metro_station):
	"""
	This function receives a Metro station name and returns a list with
	the stations that are one stop away.
	"""

	# We start by reading the csv files.
	metro = readfiles()

	# We create a list that will store the neneighbours of the list.
	neighbours = set()

	for line in metro.values():
		if metro_station in line:
			stop = line.index(metro_station)
			if stop < len(line)-1:
				neighbours.add(line[stop+1])
			if stop > 0:
				neighbours.add(line[stop-1])

	return list(neighbours)


def exercise_4(fromStation, toStation):
	class StationNode:
		def __init__(self, station, neighbours, cameFrom = 0):
			self.station = station
			self.neighbours = neighbours
			self.cameFrom = cameFrom
			
	def deep_search(fromStation,toStation,d,visited,path):
		"""Recursive function in which the inputs are:
		-head = head of the current tree branch
		-destiny= destination station
		-unique_stations=the list with stations and neighbours
		-visited= set with stations visited so far so no repeated stations are visited
		-path = the path used to get to destination"""
		found = 0
		visited.add(fromStation)
		for neighbour in d[fromStation]:
			if neighbour == toStation and neighbour not in path:
				found = 1
				path.append(neighbour)
				return path,found

			while found != 1 and neighbour not in visited: 
				fromStation = neighbour
				path,found = deep_search(fromStation,toStation,d,visited,path)
				if found == 1:
					path.append(neighbour)
					break
			
		return path,found

	def breadth_search(fromStation,toStation,d,visited,queue):
		# create the initial node/root to start searching from
		finalNode = 0
		node = StationNode(fromStation, d[fromStation])
		visited.add(node)
		queue.append(node)

		# visit all the nodes in the queue
		while queue:
			m = queue.pop(0) 
			if m.station == toStation:
				finalNode = m
				break

			for neighbour in m.neighbours:
				if not any(n.station == neighbour for n in visited):
					visited.add(StationNode(neighbour, d[neighbour], m))
					queue.append(StationNode(neighbour, d[neighbour], m))
		
		# retrieving path from nodes
		path = []
		while finalNode != 0:
			path.append(finalNode.station)
			finalNode = finalNode.cameFrom
		
		
		path.reverse()
		return path

	# list containing all the unique stations
	unique_stations = []
	for line in readfiles().values():
		for station in line:
			if station not in unique_stations:
				unique_stations.append(station)

	# get the neighbours for each station
	stations = {}
	for station in unique_stations:
		stations[station] = exercise_3(station)

	"""Tree search was done in both ways, breadth search and deep search"""
	path_breadth_search = breadth_search(fromStation,toStation,stations,set(),[])
	path_deep_search,_ = deep_search(fromStation,toStation,stations,set(),[])
	path_deep_search.append(fromStation)
	path_deep_search.reverse()

	"""Both implementations are computed and the shortest one is taken"""
	if len(path_deep_search)<len(path_breadth_search):
		return path_deep_search
	else:
		return path_breadth_search



def main():

	# Call the exercises
	print(exercise_1())
	print(exercise_2())
	print(exercise_3("Avenida de América"))
	print(exercise_4("Pinar de Chamartín", "Hospital de Fuenlabrada"))



if __name__ == '__main__':
	main()