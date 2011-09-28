require 'sqlite3'
require 'pry'

db = SQLite3::Database.new("data/iris.sqlite3.db")
rows = db.execute "Select sepal_length, sepal_width, petal_length, petal_width from iris"

puts "Sepal Length\tSepal Width\tPetal Length\tPetal Width"
rows.each do |row|
	row.each do |value|
		print "#{value}\t\t"
	end
	print "\n"
end