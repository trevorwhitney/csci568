require 'rubygems'
require 'yaml'
require_relative 'person.rb'
require_relative 'name.rb'

class Update
	def initialize
		ActiveRecord::Base.establish_connection(YAML::load(File.open('database.yml')))

		@winners = Name.find_all_by_winner(1)
		@losers = Name.find_all_by_winner(0)
	end

	def update
		@winners.each do |winner|
			winner.label = "winner"
			winner.save
		end
		@losers.each do |loser|
			loser.label = "loser"
			loser.save
		end
	end
end

update = Update.new
update.update

