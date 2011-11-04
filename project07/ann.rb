require_relative 'layer.rb'

class ArtificialNeuralNetwork
	attr_writer :input
	attr_reader :output

	#initialize with an array containing number of neurons
	#in each layer, including input and output
	def initialize(layers)
		layers.each_with_index do |layer, i|
			#calculate number of neurons in next layer, or 0
			#if this is the last layer
			next_layer = layers[i + 1] ? layers[i + 1] : 0
			layer = Layer.new(layer, next_layer)
			@layers << layer
		end
	end

	def feed_forward
		#for each layer, calculate the values entering each neuron
		#on the next layer
		@layers.each_with_index do |layer, layer_index|
			#input layer special case
			if layer_index == 0
				#create and array to hold the incoming values for each node
				#on the next layer
				@hidden = Array.new(@layers[1].neurons.size)
				
				layer.neurons.each do |neuron|
					#each "neuron" is an array of outgoing weights
					neuron.each_with_index do |weight, weight_index|
						@input.each do |input|
							@hidden[weight_index] += input * weight
						end
					end
				end
			#regular case
			else
				#figure out how many neurons are in the next layer
				new_size = @layers[layer_index + 1] ? @layers[layer_index + 1].neurons.size : 0
				
				#we only need to bother if there's another layer
				if new_size > 0
					#create a new array to store incoming values for each neuron in the next layer
					@new_hidden = Array.new(new_size)
					layer.neurons.each_with_index do |neuron, neuron_index|
						#each "neuron" is an array of outgoing weights
						neuron.each_with_index do |weight, weight_index|
							@new_hidden[weight_index] += tanh(@hidden[neuron_index]) * weight
						end
					end

					@hidden = @new_hidden
				end
			end

			#when all layers have been calculted, the "incoming" values for our last "hidden"
			#layer are really our output values
			@output = @hidden
	end

	def train
	end

	def backpropogate
	end
		
end