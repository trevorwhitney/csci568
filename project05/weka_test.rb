require "java"
require "weka/weka"

include_class "java.io.FileReader"
include_class "weka.clusterers.SimpleKMeans"
include_class "weka.core.Instances"
include_class "weka.core.Utils"

# load data file
file = FileReader.new ARGV[0]
data = Instances.new file
 
# create the model
kmeans = SimpleKMeans.new
# specify some parameters
new_options = Utils.splitOptions("-N 3")
puts new_options
kmeans.setOptions(new_options)
kmeans.buildClusterer data

#find out what's going on
puts "KMeans Available Options\n"
kmeans.listOptions.each do |option|
	puts "Description: #{option.description}"
	puts "Synopsis: #{option.synopsis}"
end
puts "KMeans Current Options\n"
kmeans.getOptions.each do |option|
	puts option
end

puts "Current number of clusters: #{kmeans.getNumClusters}\n"

# print out the built model
print kmeans

# Display the cluster for each instance
data.numInstances.times do |i|
  cluster = "UNKNOWN"
  begin
    cluster = kmeans.clusterInstance(data.instance(i))
  rescue java.lang.Exception
  end
  puts "#{data.instance(i)},#{cluster}"
end