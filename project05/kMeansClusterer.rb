require 'java'
require 'rubygems'
require 'jdbc/sqlite3'
require 'pry'

class KMeansClusterer
	attr_reader :cluster_centroids, :best_matches

	def initialize
		url = "jdbc:sqlite:data/iris.sqlite3.db"
		begin
 			Java::org.sqlite.JDBC
 			db = java.sql.DriverManager.get_connection(url)
 		rescue => error
 			puts "couldn't connect to database, this is bad"
 		end

 		stmt = db.create_statement
		db_data = stmt.execute_query "Select sepal_length, sepal_width, petal_length, petal_width from iris"
		num_attributes = db_data.getMetaData.getColumnCount
		@data = {}
		count = 0

		while db_data.next
			row = []
			for i in 0...num_attributes
				row[i] = db_data.getFloat(i+1)
			end
			@data[count] = row
			count += 1
		end
 	end

 	def buildClusters(num_clusters)
 		@num_clusters = num_clusters
 		num_attributes = @data[0].length

 		#find bounds of data
 		data_boundaries = {}
 		for i in 0...num_attributes
 			boundaries = []
 			boundaries[0] = @data[0][i]
 			boundaries[1] = @data[0][i]
 			data_boundaries[i] = boundaries
 		end
 		@data.each do |row, values|
 			for i in 0...num_attributes
 				data_boundaries[i][0] = values[i] if values[i] < data_boundaries[i][0]
 				data_boundaries[i][1] = values[i] if values[i] > data_boundaries[i][1]
 			end
 		end


 		#set initial centroids
 		@cluster_centroids = {}
 		
 		for c in 0...num_clusters
 			row = []
 			for i in 0...num_attributes
 				row[i] = Random.rand*(data_boundaries[i][1] - data_boundaries[i][0])+data_boundaries[i][0]
 			end
 			@cluster_centroids[c] = row
 		end


 		#keep track of previous match so know when we're done
 		previous_matches = nil

 		#for max iterations, go through and cluster
		for t in 0...100
 			puts "Iteration ##{t}"
 			@best_matches = {}

 			for i in 0...num_clusters
 				@best_matches[i] = []
 			end

 			#loop through each row in the data set
 			@data.each do |row, values|
 				bestmatch = 0
 				for i in 0...num_clusters
 					distance = euclideanDistance(@cluster_centroids[i], values)
 					bestmatch = i if distance < euclideanDistance(@cluster_centroids[bestmatch], values)
 				end
 				@best_matches[bestmatch] << row
 			end


 			#done if the centroids didn't move
 			break if @best_matches == previous_matches
 			previous_matches = @best_matches

 			@best_matches.each do |cluster, values|
 				averages = [0.0]*num_attributes
 				if values.length > 0
 					values.each do |rowid|
 						for j in 0...num_attributes
 							averages[j] += @data[rowid][j]
 						end
 					end

 					for j in 0...num_attributes
 						averages[j] = averages[j]/@best_matches[cluster].length
 					end

 					@cluster_centroids[cluster] = averages
 				end
 			end
		end
	end

 	def euclideanDistance(values1, values2)
		@distance = 0
		values1.each_index do |i|
			dif_squared = (values1[i] - values2[i])**2
			@distance += dif_squared
		end

		#we want lower numbers to mean closer
		euc = 1 / (1 + Math.sqrt(@distance))
		return 1 - euc
 	end

 	def getSSE
 		#sum of distance from record to centroid for each cluster
 		@sse = [0.0]*@num_clusters
 		@best_matches.each do |cluster, values|
 			if values.length > 0
 				values.each do |row|
 					@sse[cluster] += euclideanDistance(@cluster_centroids[cluster], @data[row])
 				end
 			end
 		end

 		@sse
 	end

end