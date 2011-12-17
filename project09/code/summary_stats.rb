require 'rubygems'
require 'yaml'
require 'active_record'
require 'csv'
require 'pry'

#require the models
Dir['model/*.rb'].each {|file| require_relative file}

class SummaryStatistics
  def initialize
    ActiveRecord::Base.establish_connection YAML::load(File.open('config/db.yaml'))
  end

  def all_stats
    puts "Users: #{user_stats}\n"
    puts "Tracks: #{track_stats}\n"
    puts "Artists: #{artist_stats}\n"
    puts "Albums: #{album_stats}\n"
    puts "Genres: #{genre_stats}\n"
  end

  def track_stats
    total_tracks = Track.all.size

  end

  def artist_stats
    total_artists = Artist.all.size
  end

  def album_stats
    total_albums = Album.all.size
  end

  def user_stats
    total_users = User.all.size 
  end

  def genre_stats
    total_genres = Genre.all.size
  end

end

stats = SummaryStatistics.new
stats.all_stats