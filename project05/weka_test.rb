require "java"
require "rubygems"
require "weka/weka"
require "jdbc/sqlite3"

include_class "weka.clusterers.SimpleKMeans"
include_class "weka.core.Instances"
include_class "weka.core.Utils"
include_class "weka.core.Instance"
include_class "weka.core.Attribute"
include_class "weka.core.FastVector"

def make_vector *args
	atts = FastVector.new(args.length)
	args.each {|arg| atts.addElement arg}
	return atts
end

# load data file
#file = FileReader.new ARGV[0]
#data = Instances.new file
 
 url = "jdbc:sqlite:data/iris.sqlite3.db"
 #db = SQLite3::Database.new("data/iris.sqlite3.db")
 begin
 	Java::org.sqlite.JDBC
 	db = java.sql.DriverManager.get_connection(url)
 rescue => error
 	puts "couldn't connect"
 end
 stmt = db.create_statement
 count = stmt.execute_query "Select count(*) from iris"
 rows = stmt.execute_query "Select sepal_length, sepal_width, petal_length, petal_width from iris"

 num = count.getInt(1)

# create the model
kmeans = SimpleKMeans.new
# specify some parameters
new_options = Utils.splitOptions("-N 3")
kmeans.setOptions(new_options)

#kmeans.buildClusterer data

sepal_length = Attribute.new("sepal_length")
sepal_width = Attribute.new("sepal_width")
petal_length = Attribute.new("petal_length")
petal_width = Attribute.new("petal_width")

dataset = Instances.new(
	"iris dataset",
	make_vector(sepal_length, sepal_width, petal_length, petal_width),
	num)

while rows.next
	instance = Instance.new 4
	instance.setValue(sepal_length, rows.getFloat(1))
	instance.setValue(sepal_width, rows.getFloat(2))
	instance.setValue(petal_length, rows.getFloat(3))
	instance.setValue(petal_width, rows.getFloat(4))
	instance.setDataset dataset
	dataset.add instance
end

kmeans.buildClusterer dataset

#find out what's going on
#puts "KMeans Available Options\n"
#kmeans.listOptions.each do |option|
#	puts "Description: #{option.description}"
#	puts "Synopsis: #{option.synopsis}"
#end
#puts "KMeans Current Options\n"
#kmeans.getOptions.each do |option|
#	puts option
#end

#puts "Current number of clusters: #{kmeans.getNumClusters}\n"

# print out the built model
print kmeans

# Display the cluster for each instance
dataset.numInstances.times do |i|
  cluster = "UNKNOWN"
  begin
    cluster = kmeans.clusterInstance(dataset.instance(i))
  rescue java.lang.Exception
  end
  puts "#{dataset.instance(i)}, #{cluster}"
end

stmt.close
db.close 