require 'test/unit'
require_relative 'ann.rb'

class TestArtificialNeuralNetwork < Test::Unit::TestCase
	def setup
		@layers = [3, 2, 3]
		@input = [1.0, 0.25, -0.5]
		@output = [1.0, -1.0, 0.0]
	end

	def test_input
		@ann = ArtificialNeuralNetwork.new(@layers)
		@ann.input = [1, 0.25]
		assert(@ann.input.nil?)

		@ann.input = @input
		assert_not_nil(@ann.input)

	end

	def test_feed_forward
		@ann = ArtificialNeuralNetwork.new(@layers)
		@ann.input = @input
		@ann.feed_forward
		output = @ann.output
		printf "Output after feed forward: %.4f, %.4f, %.4f\n" % output

		assert_equal(3, output.size)
		assert(output[0].abs <= 1)
		assert(output[1].abs <= 1)
		assert(output[2].abs <= 1)
	end

	def test_train
		@ann = ArtificialNeuralNetwork.new(@layers)
		iterations = 30
		@ann.train(@input, @output, iterations)
		output = @ann.output
		printf "Output after training for #{iterations} iterations: %.1f, %.1f, %.1f\n" % output

		assert_equal(@output, output)
	end
end