require 'rubygems'
require 'yaml'
require 'active_record'
require 'csv'
require 'pry'

#require the models
Dir['model/*.rb'].each {|file| require_relative file}

class Compare
  def initialize
    ActiveRecord::Base.establish_connection YAML::load(File.open('config/db.yaml'))
  end

  def find_similarities
    ids = user_ids
    all_users_elements = Hash.new

    puts "Finding each users ratings..."
    ids.each do |id|
      elements = Rating.find :all, :conditions => "user_id = #{id}",
        :select => "item_id"
      all_element_ids = Array.new
      elements.each do |e|
        all_element_ids << e.item_id.to_i
      end
      all_users_elements[id] = all_element_ids
    end
  
    #find similarities

    #start at first user
    cur_user1 = 0
    max_user = ids[ids.size - 1]
    
    #once the last user is reached, all other relationships to him will have
    #already been calculated, since each iterations calculates the similarity between
    #it self and the Nth user, where N is the number of users in the set
    (all_users_elements.size - 1).times do
      user1 = ids[cur_user1]
      cur_user2 = cur_user1 + 1
      #calculate similarity between current user and ever user from cur_user + 1
      #to the Nth user
      while cur_user2 <= max_user
        user2 = ids[cur_user2]
        user1_all_elements = all_users_elements[user1]
        user2_all_elements = all_users_elements[user2]

        #calculate similarity for each type and create the record
        %w(track album artist genre).each do |type|
          sim_score = similarity_score type, user1, user1_all_elements, user2, user2_all_elements
          sim = Similarity.new do |s|
            s.user1_id = user1
            s.user2_id = user2
            s.score = sim_score
            s.type = type
            s.save!
          end
        end
        cur_user2 += 1
      end
      cur_user1 += 1
    end
  end

  def user_ids
    puts "Finding all users..."
    users = User.all
    @user_ids = Array.new
    users.each do |u|
      @user_ids << u.id
    end
    @user_ids.sort
  end

  def similarity_score(element_type, user1_id, user1_all_elements, 
      user2_id, user2_all_elements)
    if element_type == "track"
      elements = Track.find :all, :select => "id"
    elsif element_type == "album"
      elements = Album.find :all, :select => "id"
    elsif element_type == "artist"
      elements = Artist.find :all, :select => "id"
    elsif element_type == "genre"
      elements = Genre.find :all, :select => "id"
    else
      puts "Wrong element type. Must be track, album, artist, or genre"
      return -1
    end

    puts "Finding similar #{element_type} items between user #{user1_id} and user #{user2_id}..."

    element_ids = ids_of elements

    user1_elements = user1_all_elements & element_ids
    user2_elements = user2_all_elements & element_ids

    user1_ratings = find_ratings user1_id, user1_elements
    user2_ratings = find_ratings user2_id, user2_elements

    shared_elements = user1_elements & user2_elements

    puts "Calculating pearsons score..."
    similarity = euclidean(user1_ratings, user2_ratings, shared_elements)
    return similarity
  end

  def ids_of(elements)
    ids = Array.new
    elements.each do |e|
      ids << e.id.to_i
    end
    return ids
  end

  def pearsons(user1_ratings, user2_ratings, shared_elements)
    return 0 if shared_elements.empty?

    sum1, sum2, sum1Sq, sum2Sq, productSum = 0, 0, 0, 0, 0
    shared_elements.each do |element|
      sum1 += user1_ratings[element]
      sum2 += user2_ratings[element]
      sum1Sq += user1_ratings[element]**2
      sum2Sq += user2_ratings[element]**2
      productSum += user1_ratings[element]*user2_ratings[element]
    end

    #Pearson score
    numerator = productSum - (sum1*sum2/shared_elements.length)
    denomenator = Math.sqrt((sum1Sq-(sum1**2)/shared_elements.length)*(sum2Sq-(sum2**2)/shared_elements.length))
    
    #binding.pry
    return 0 if denomenator == 0

    r = numerator/denomenator
  end

  def euclidean(user1_ratings, user2_ratings, shared_elements)
    return 0 if shared_elements.empty?

    @sim = 0
    shared_elements.each do |element|
      dif_squared = (user1_ratings[element] - user2_ratings[element])**2
      @sim += dif_squared
    end

    #binding.pry
    euc = 1 / (1 + Math.sqrt(@sim))
  end
  
  def find_ratings(user_id, elements)
    ratings = Hash.new
    elements.each do |element|
      rating = Rating.find_by_user_id_and_item_id user_id, element
      ratings[element] = rating.score.to_i
    end
    return ratings
  end

 


end

compare = Compare.new
compare.find_similarities