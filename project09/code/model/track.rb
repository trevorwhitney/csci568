class Track < ActiveRecord::Base
  has_and_belongs_to_many :genres
  belongs_to :album
  belongs_to :artist
end