class AddMiddleNameToNames < ActiveRecord::Migration
	def self.up
		add_column :names, :middleNameCharCount, :integer
	end

	def self.down
		remove_column :names; :middleNameCharCount
	end
end