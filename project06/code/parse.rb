require 'rubygems'
require 'yaml'
require_relative 'person.rb'
require_relative 'name.rb'

class Parse
	def initialize
		ActiveRecord::Base.establish_connection(YAML::load(File.open('database.yml')))

		@winners = Person.find_all_by_label(" + ")
		@losers = Person.find_all_by_label(" - ")
	end

	def populate
		@winners.each do |winner|
			name = build_name winner
			name.label = "winner"
			name.save
		end

		@losers.each do |loser|
			name = build_name loser
			name.label = "loser"
			name.save
		end
	end

	def build_name(person)
		name = Name.new
		name.name = person.name
		if person.name[1].scan(/[aeiou]+/).length > 0
			name.secondLetterVowel = 1
		else
			name.secondLetterVowel = 0
		end
		return name
	end

	end