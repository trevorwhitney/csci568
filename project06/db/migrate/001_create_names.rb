class CreateNames < ActiveRecord::Migration
	def self.up
		create_table :names do |t|
			t.column :name, :string
			t.column :winner, :integer
			t.column :firstNameCharCount, :integer
			t.column :lastNameCharCount, :integer
			t.column :nameCharCount, :integer
			t.column :firstNameFirstChar, :string
			t.column :firstNameLastChar, :string
			t.column :lastNameFirstChar, :string
			t.column :lastNameLastChar, :string
			t.column :firstNameVowelCount, :integer
			t.column :lastNameVowelCount, :integer
			t.column :nameVowelCount, :integer
		end
	end

	def self.down
		drop_table :names
	end
end