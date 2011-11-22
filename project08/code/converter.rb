require 'csv'

class Converter
	def initialize(file)
		@file = file
	end

	def calculate_decimal_values(header_present)
		first = true
		field_values = Array.new
		CSV.foreach(@file, :col_sep => ',') do |row|
			#first time through, create an array with the correct
			#number of columns to hold all the possible values for
			#each column
			if first
				row.size.times do
					field_values << Array.new
				end
				first = false
				if header_present
					@header = Array.new
					row.each do |value|
						@header << value
					end
					next
				end
			end
			
			row.each_with_index do |value, column|
				#collect an array of all unique values for each column
				field_values[column] << value unless field_values[column].include? value
			end
		end
		
		value_mapping = Array.new(field_values.size)
		field_values.each_with_index do |values, column|
			field = {}
			values.each_with_index do |value, index|
				#keep our class values as strings
				if column == 0
					field[value] = value
				elsif
					#each value is assigned a number between 1..N, where
					#N is the number of possible values. This is then divided
					#by N to create a unique decimal value between 0..1 for
					#each value, which is then stored in a map
					field[value] = (index + 1.0)/values.size
				end
			end
			value_mapping[column] = field
		end
		@decimal_values = value_mapping
	end

	def convert(newfile)
		CSV.open(newfile, "w") do |csv|
			#header
			if @header
				csv << @header
			else
				csv << %w(class cap-shape cap-surface cap-color bruises? odor 
					gill-attachment gill-spacing gill-size gill-color stalk-shape
					stalk-root stalk-surface-above-ring stalk-surface-below-ring 
					stalk-color-above-ring stalk-color-below-ring veil-type veil-color
					ring-number ring-type spore-print-color population habitat)
			end
			#data
			first = true
			CSV.foreach(@file, :col_sep => ',') do |row|
				if @header && first
					first = false
					next
				end
				row_values = Array.new
				row.each_with_index do |value, index|
					row_values << @decimal_values[index][value]
				end
				csv << row_values
			end
		end

	end


end

