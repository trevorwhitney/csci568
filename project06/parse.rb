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
			name = buildName winner
			name.winner = 1
			name.save
		end

		@losers.each do |loser|
			name = buildName loser
			name.winner = 0
			name.save
		end
	end

	def buildName(person)
		name = Name.new
		name.name = person.name

		firstName, secondName, lastName = person.name.split(' ')

		firstName.strip!
		secondName.strip!
		lastName.strip! if lastName

		name.firstNameCharCount = firstName.length
		name.firstNameFirstChar = firstName[0]
		name.firstNameLastChar = firstName[-1]
		name.firstNameVowelCount = firstName.scan(/[aeiou]+/).length
		if lastName
			name.middleNameCharCount = secondName.gsub(/\./, "").length
			name.middleNameFirstChar = secondName[0]
			name.middleNameLastChar = secondName.gsub(/\./, "")[-1]
			name.middleNameVowelCount = secondName.scan(/[aeiou]+/).length
			name.lastNameCharCount = lastName.length
			name.lastNameFirstChar = lastName[0]
			name.lastNameLastChar = lastName[-1]
			name.lastNameVowelCount = lastName.scan(/[aeiou]+/).length
		else
			name.middleNameCharCount = 0
			name.middleNameVowelCount = 0
			name.lastNameCharCount = secondName.length
			name.lastNameFirstChar = secondName[0]
			name.lastNameLastChar = secondName[1]
			name.lastNameVowelCount = secondName.scan(/[aeiou]+/).length
			name.nameVowelCount = name.firstNameVowelCount + name.lastNameVowelCount
		end

		name.nameCharCount = name.firstNameCharCount + name.middleNameCharCount + name.lastNameCharCount
		name.nameVowelCount = name.firstNameVowelCount + name.middleNameVowelCount + name.lastNameVowelCount
		return name
	end
end

