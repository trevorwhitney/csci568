require_relative 'layer.rb'

class ArtificialNeuralNetwork
	attr_writer :input

	#initialize with array representing number of neurons
	#in each layer
	def initialize(layers)
		layers.each_idex do |i|
			next_layer = layers[i + 1] ? layers[i + 1] : 0
			layer = Layer.new(layers[i], next_layer)
			@layers << layer
		end
	end

	def output
	end

	def train
	end

	def backpropogate
	end
		
end