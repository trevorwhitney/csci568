require 'test/unit'
require_relative	'euclidean'

class TestSimilarityMetrics < Test::Unit::TestCase

	MOVIES = [ "Nightmare on Elm Street",
           "Dreamcatcher",
           "Super Troopers",
           "Fear and Loathing in Las Vegas",
           "Parent Trap",
           "Muppets Take Manhattan",
           "Sex and the City",
           "Revolutionary Road",
           "Source Code",
           "The Matrix",
           "Hackers",
           "Titanic",
           "The Bounty Hunter",
           "Valkyrie",
           "Jarhead",
           "Apocalypse Now",
           "Taxi Driver",
           "Midnight in Paris",
           "Black Swan",
           "Friday"
        	]

	POSSIBLE_RATINGS = (1..4).to_a

	PEOPLE = %w( trevor joe steve )

	def setup
		#@ratings = generate_ratings(MOVIES, PEOPLE, POSSIBLE_RATINGS)
		@trevor = {"Super Troopers" => 4, "Friday" => 1, "The Matrix" => 3}
		@trevor_clone = {"Super Troopers" => 4, "Friday" => 1, "The Matrix" => 3}
		@trevor_other = {"Super Troopers" => 1, "Friday" => 4, "The Matrix" => 2}
		@trevor_dif = {"Jarhead" => 3, "Black Swan" => 4, "Titanic" => 1}
	end

	def test_euclidean
		@euclidean1 = EuclideanDistance.new(@trevor, @trevor_clone)
		@euclidean0 = EuclideanDistance.new(@trevor, @trevor_dif)
		@euclidean = EuclideanDistance.new(@trevor, @trevor_other)

		assert_equal(1, @euclidean1.similarity)
		assert_equal(0, @euclidean0.similarity)
		assert_equal(0.5, @euclidean.similarity)
		
	end


	private

	def generate_ratings(movies, people, possible_ratings)
		{}.tap do |ratingset|
    	people.each do |person|
      	ratingset[person] = {}.tap do |ratings|
        	movies.sort_by{ rand }.slice(0..20).each do |flick|
          	ratings[flick] = possible_ratings[rand(possible_ratings.size)]
          end
      	end
    	end
  	end
	end

end