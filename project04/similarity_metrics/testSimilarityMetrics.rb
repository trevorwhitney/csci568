require 'test/unit'
require_relative	'euclidean'
require_relative	'pearson'
require_relative	'smc'
require_relative	'jaccard'
require_relative	'cosine'

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
		#Header: Apples, Beer, Diapers, Beef, Chicken
		@basket1 = [1, 1, 1, 0, 0]
		@basket1_clone = [1, 1, 1, 0, 0]
		@basket1_opposite = [0, 0, 0, 1, 1]
		@basket2 = [1, 0, 0, 0, 1]

		#Document vectors
		@document1 = [3, 2, 0, 5, 0, 0, 0, 2, 0, 0]
		@document1_clone = [3, 2, 0, 5, 0, 0, 0, 2, 0, 0]
		@empty_document = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
		@document2 = [1, 0, 0, 0, 0, 0, 0, 1, 0, 2]
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

	def test_jaccard
		@jaccard1 = JaccardCoefficient.new(@basket1, @basket1_clone)
		@jaccard0 = JaccardCoefficient.new(@basket1, @basket1_opposite)
		@jaccard = JaccardCoefficient.new(@basket1, @basket2)

		assert_equal(1, @jaccard1.similarity)
		assert_equal(0, @jaccard0.similarity)
		assert_equal(0.25, @jaccard.similarity)
	end

	def test_smc
		@smc1 = SimpleMatchingCoefficient.new(@basket1, @basket1_clone)
		@smc0 = SimpleMatchingCoefficient.new(@basket1, @basket1_opposite)
		@smc = SimpleMatchingCoefficient.new(@basket1, @basket2)

		assert_equal(1, @smc1.similarity)
		assert_equal(0, @smc0.similarity)
		assert_equal(0.4, @smc.similarity)
	end

	def test_cosine
		@cosine1 = CosineSimilarity.new(@document1, @document1_clone)
		@cosine0 = CosineSimilarity.new(@document1, @empty_document)
		@cosine = CosineSimilarity.new(@document1, @document2)

		assert_equal(1, @cosine1.similarity)
		assert_equal(0, @cosine0.similarity)
		assert_equal(0.314970394174356, @cosine.similarity)
		
	end

end