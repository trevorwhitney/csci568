require 'test/unit'
require "java"
require "rubygems"
require "weka/weka"
require "jdbc/sqlite3"

require_relative "KMeansClusterer"

include_class "weka.clusterers.SimpleKMeans"
include_class "weka.core.Instances"
include_class "weka.core.Utils"
include_class "weka.core.Instance"
include_class "weka.core.Attribute"
include_class "weka.core.FastVector"


class TestClusters << Test::Unit::TestCase

	def setup
		url = "jdbc:sqlite:data/iris.sqlite3.db"
	 	begin
 			Java::org.sqlite.JDBC
 			db = java.sql.DriverManager.get_connection(url)
 		rescue => error
 			puts "couldn't connect to database, this is a problem"
 		end

 		#talk to db
 		stmt = db.create_statement
 		count = stmt.execute_query "Select count(*) from iris"
 		rows = stmt.execute_query "Select sepal_length, sepal_width, petal_length, petal_width from iris"

 		num = count.getInt(1)

		# create the model
		kmeans = SimpleKMeans.new

		# specify cluster parameters
		new_options = Utils.splitOptions("-N 3")
		kmeans.setOptions(new_options)

		#define attributes
		sepal_length = Attribute.new("sepal_length")
		sepal_width = Attribute.new("sepal_width")
		petal_length = Attribute.new("petal_length")
		petal_width = Attribute.new("petal_width")

		#create dataset
		dataset = Instances.new(
			"iris dataset",
			make_vector(sepal_length, sepal_width, petal_length, petal_width),
			num)

		#add records to dataset
		while rows.next
			instance = Instance.new 4
			instance.setValue(sepal_length, rows.getFloat(1))
			instance.setValue(sepal_width, rows.getFloat(2))
			instance.setValue(petal_length, rows.getFloat(3))
			instance.setValue(petal_width, rows.getFloat(4))
			instance.setDataset dataset
			dataset.add instance
		end

		#build cluseters
		kmeans.buildClusterer dataset
		sizes = kmeans.clusterSizes
		@size1, @size2, @size3 = *sizes
		@sumSSE = kmeans.getSquaredError

		stmt.close
		db.close
	end


	def make_vector *args
		atts = FastVector.new(args.length)
		args.each {|arg| atts.addElement arg}
		return atts
	end


	#### Here are the tests ####

	def test_cluster

		clusterer = KMeansClusterer.new
		
	end

end