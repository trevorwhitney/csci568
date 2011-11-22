require_relative "converter.rb"

converter = Converter.new(ARGV[0])
converter.calculate_decimal_values(true)
converter.convert('data/mushroom.decimal-data.csv')