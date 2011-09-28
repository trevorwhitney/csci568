require 'java'
require 'rubygems'
require 'jdbc/sqlite3'

class KMeansClusterer
	attr_reader :clusters

	def initialize
		url = "jdbc:sqlite:data/iris.sqlite3.db"
		begin
 			Java::org.sqlite.JDBC
 			db = java.sql.DriverManager.get_connection(url)
 		rescue => error
 			puts "couldn't connect to database, this is bad"
 		end
 		stmt = db.create_statement
 		@data = stmt.execute_query "Select sepal_length, sepal_width, petal_length, petal_width from iris"
 		stmt.close
 		db.close
 	end

 	def buildClusters(num_clusters)
 		@clusters = {}

 		num_attributes = @data.getMetaData.getColumnCount

 		#find bounds of data
 		data_boundaries = [[0]*2]*4
 		for i in 0..num_attributes
 			data_boundaries[i][0] = @data.getFloat(i)
 			data_boundaries[i][1] = @data.getFloat(i)
 		end
 		
 		while @data.next
 			for i in 0..num_attributes
 				data_boundaries[i][0] = @data.getFloat(i) if @data.getFloat(i) < data_boundaries[i][0]
 				data_boundaries[i][1] = @data.getFloat(i) if @data.getFloat(i) > data_boundaries[i][1]
 			end
 		end

 		#set initial centroids
 		for c in 0..num_clusters
 			for i in 0..num_attributes
 				cluster_centroids[c][i] = Random.rand*(data_boundaries[i][1] - data_boundaries[i][0])+data_boundaries[i][0]
 			end

 		#keep track of previous match so know when we're done
 		previousMatch = nil

 		#for max iterations, go through and cluster
 		for t in 0..100
 			#TODO: run the actual cluster

 			#reset data object
 			@data.first
 		end

 			
 	end

 	def euclideanDistance(values1, values2)
		@distance = 0
		values1.each_index do |i|
			dif_squared = (values1[i] - values2[i])**2
			@distance += dif_squared
		end

		#we want lower numbers to mean closer
		euc = 1 / (1 + Math.sqrt(@sim))
		return 1 - euc
 	end

end