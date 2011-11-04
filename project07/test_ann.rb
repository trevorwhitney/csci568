require 'test/unit'
require_relative 'ann.rb'

class TestArtificialNeuralNetwork < Test::Unit::TestCase
	def setup
		layers = [3, 2, 3]
		@ann = ArtificialNeuralNetwork.new(layers)
	end

	def test_input
		@ann.input = [1, 0.25]
		assert(@ann.input.nil?)

		@ann.input = [1, 0.25, -0.5]
		assert_not_nil(@ann.input)

	end

	def test_feed_forward
		@ann.input = [1, 0.25, -0.5]
		@ann.feed_forward
		output = @ann.output
		printf "Output after feed forward: %.4f, %.4f, %.4f\n" % output

		assert_equal(3, output.size)
		assert(output[0].abs <= 1)
		assert(output[1].abs <= 1)
		assert(output[2].abs <= 1)
	end

	def test_train
	end
end