require 'test/unit'
require_relative	'euclidean'
require_relative	'pearson'
require_relative	'smc'

class TestSimilarityMetrics < Test::Unit::TestCase

	def setup
		#Movie Ratings
		@trevor = {"Super Troopers" => 4, "Friday" => 1, "The Matrix" => 3}
		@trevor_clone = {"Super Troopers" => 4, "Friday" => 1, "The Matrix" => 3}
		@trevor_other = {"Super Troopers" => 1, "Friday" => 4, "The Matrix" => 2}
		@trevor_dif = {"Jarhead" => 3, "Black Swan" => 4, "Titanic" => 1}
		@trevor_high = {"Super Troopers" => 4, "Friday" => 3, "The Matrix" => 4}
		@trevor_low = {"Super Troopers" => 2, "Friday" => 1, "The Matrix" => 2}
		@lisa = {"Lady in the Water" => 2.5, "Snakes on a Plane" => 3.5,
									"Just My Luck" => 3.0, "Superman Returns" => 3.5, "You, Me and Dupree" => 2.5,
									"The Night Listener" => 3.0}
		@gene = {'Lady in the Water' => 3.0, 'Snakes on a Plane' => 3.5,
							'Just My Luck' => 1.5, 'Superman Returns' => 5.0, 'The Night Listener' => 3.0,
							'You, Me and Dupree' => 3.5}

		#Market basket data
		@basket1 = {"Apples" => 1, "Beer" => 1, "Diapers" => 1, "Beef" => 0, "Chicken" => 0}
		@basket1_clone = {"Apples" => 1, "Beer" => 1, "Diapers" => 1, "Beef" => 0, "Chicken" => 0}
		@basket1_opposite = {"Apples" => 0, "Beer" => 0, "Diapers" => 0, "Beef" => 1, "Chicken" => 1}
		@basket2 = {"Apples" => 1, "Beer" => 0, "Diapers" => 0, "Beef" => 0, "Chicken" => 1}
	end

	def test_euclidean
		@euclidean1 = EuclideanDistance.new(@trevor, @trevor_clone)
		@euclidean0 = EuclideanDistance.new(@trevor, @trevor_dif)
		@euclidean = EuclideanDistance.new(@trevor, @trevor_other)

		assert_equal(1, @euclidean1.similarity)
		assert_equal(0, @euclidean0.similarity)
		assert_equal(1/(1 + Math.sqrt(19)), @euclidean.similarity)
	end

	def test_pearson
		@pearson1 = PearsonCorrelation.new(@trevor, @trevor_clone)
		@pearson0 = PearsonCorrelation.new(@trevor, @trevor_dif)
		@pearson_normal = PearsonCorrelation.new(@trevor_high, @trevor_low)
		@pearson = PearsonCorrelation.new(@trevor, @trevor_other)
		@pearson_book = PearsonCorrelation.new(@lisa, @gene)

		assert_equal(1, @pearson1.similarity)
		assert_equal(0, @pearson0.similarity)
		assert_equal(1, @pearson_normal.similarity)
		assert_equal(-0.8, @pearson.similarity)
		assert_equal(0.39605901719066977, @pearson_book.similarity)
	end

	def test_smc
		@smc1 = SimpleMatchingCoefficient.new(@basket1, @basket1_clone)
		@smc0 = SimpleMatchingCoefficient.new(@basket1, @basket1_opposite)
		@smc = SimpleMatchingCoefficient.new(@basket1, @basket2)

		assert_equal(1, @smc1.similarity)
		assert_equal(0, @smc0.similarity)
		assert_equal(0.4, @smc.similarity)
	end

end