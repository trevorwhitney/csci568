require 'rubygems'
require 'yaml'
require 'active_record'
require 'csv'
require 'pry'

#require the models
Dir['model/*.rb'].each {|file| require_relative file}

class Populate
  def initialize
    ActiveRecord::Base.establish_connection YAML::load(File.open('config/db.yaml'))
  end

  def load_all
    puts "Loading all data..."
    #Load Artists, Genres, Albums, Tracks, Users, Ratings
    load_artists
    puts "Loaded artists..."
    load_genres
    puts "Loaded genres..."
    load_albums
    puts "Loaded albums..."
    load_tracks
    puts "Loaded tracks..."
    load_users_and_ratings
    puts "Loaded users and ratings..."
    puts "Loading finished."
  end


  #Define methods for loading
  def load_artists
    CSV.foreach('data/track1/artistData1.txt', {:col_sep => '|'}) do |row|
      row.each do |value|
        Artist.new do |a|
          a.id = value.to_i
          a.save
        end
        puts "Created artist with id: #{value}"
      end
    end
  end

  def load_genres
    CSV.foreach('data/track1/genreData1.txt', {:col_sep => '|'}) do |row|
      row.each do |value|
        Genre.new do |g|
          g.id = value.to_i
          g.save
        end
        puts "Created genre with id: #{value}"
      end
    end
  end

  def load_albums
    count = 0
    CSV.foreach('data/track1/albumData1.txt', {:col_sep => '|'}) do |row|
      album = Album.new do |a|
        a.id = row[0].to_i
        unless row[1] == "None"
          a.artist = Artist.find row[1].to_i
        end
      end
      if row.size > 2
        genres = Array.new
        (row.size - 2).times do |i|
          genres << row[i + 2].to_i
        end
        genres.each do |g|
          genre = Genre.find_or_create_by_id g
          album.genres << genre
        end
      end
      puts "#{count}.) Created album with id: #{row[0]}, artist: #{row[1]}, and #{row.size - 2} genres"
      count += 1
      album.save!
    end
  end

  def load_tracks
    CSV.foreach('data/track1/trackData1.txt', {:col_sep => '|'}) do |row|
      track = Track.new do |t|
        t.id = row[0]
        t.album = Album.find row[1].to_i unless row[1] == "None"
        t.artist = Artist.find row[2].to_i unless row[2] == "None"
      end
      
      if row.size > 3
        genres = Array.new
        (row.size - 3).times do |i|
          genres << row[i + 2].to_i
        end
        genres.each do |g|
          genre = Genre.find_or_create_by_id g
          track.genres << genre
        end
      end
      puts "Created track with id: #{row[0]}"
      track.save!
    end
  end

  def load_users_and_ratings
    training_data = File.open('data/track1/trainIdx1.firstLines.txt').readlines
    headers = Array.new 
    training_data.each_with_index do |line, index|
      if line =~ /^[\d]+\|[\d]+$/
        #line is [index, user, # of ratings]
        lines = Array.new(3)
        lines[0] = index
        lines[1] = line[/^[\d]+/].to_i
        lines[2] = line[/[\d]+$/].to_i
        headers << lines
      end
    end

    headers.each do |header_values|
      index = header_values[0] + 1
      user = User.new do |u|
        u.id = header_values[1]
        u.save!
      end
      header_values[2].times do
        line = training_data[index]
        line_a = line.split("\t")
        rating = Rating.new :item_id => line_a[0].to_i, :score => line_a[1].to_i, :date => line_a[2].to_i,
          :time => line_a[3].to_i
        rating.user = user
        rating.save!
        index += 1
      end
      puts "Created user with id: #{header_values[1]} and #{header_values[2]} ratings"
    end
  end

end

Populate.new.load_all



