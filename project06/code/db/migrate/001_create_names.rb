class CreateNames < ActiveRecord::Migration
	def self.up
		create_table :names do |t|
			t.column :name, :string
			t.column :secondLetterVowel, :integer
			t.column :label, :string
		end
	end

	def self.down
		drop_table :names
	end
end