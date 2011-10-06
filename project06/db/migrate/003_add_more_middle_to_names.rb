class AddMoreMiddleToNames < ActiveRecord::Migration
	def self.up
		add_column :names, :middleNameFirstChar, :string
		add_column :names, :middleNameLastChar, :string
		add_column :names, :middleNameVowelCount, :integer
	end

	def self.down
		remove_column :names, :middleNameFirstChar
		remove_column :names, :middleNameLastChar
		remove_column :names, :middleNameVowelCount
	end
end