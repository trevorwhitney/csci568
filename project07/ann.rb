require 'rubygems'
require 'pry'
require_relative 'layer.rb'

class ArtificialNeuralNetwork
	attr_reader :output, :input

	#initialize with an array containing number of neurons
	#in each layer, including input and output
	def initialize(layers)
		@layers = Array.new
		layers.each_with_index do |layer, i|
			#calculate number of neurons in next layer, or 0
			#if this is the last layer
			next_layer = layers[i + 1] ? layers[i + 1] : 0
			layer = Layer.new(layer, next_layer)
			@layers << layer
		end
	end

	def input=(input)
		if input.size == @layers[0].neurons.size
			@input = input
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
				@values = Array.new
				@layers[1].neurons.size.times do
					@values << 0.0
				end
				
				@values.each_index do |i|
					sum = 0.0
					#each "neuron" is an array of outgoing weights
					layer.neurons.each_with_index do |neuron, neuron_index|
						sum = sum + @input[neuron_index] * neuron[i]
					end
					@values[i] = Math.tanh(sum)
				end
				layer.values = @input
			#regular case
			else
				#figure out how many neurons are in the next layer
				new_size = @layers[layer_index + 1] ? @layers[layer_index + 1].neurons.size : 0
				
				#we only need to bother if there's another layer
				if new_size > 0
					#create a new array to store incoming values for each neuron in the next layer
					@new_values = Array.new
					new_size.times do
						@new_values << 0.0
					end

					#store the current layer's values
					layer.values = @values

					@new_values.each_index do |i|
						sum = 0.0
						#each "neuron" is an array of outgoing weights
						layer.neurons.each_with_index do |neuron, neuron_index|
							sum = sum + @values[neuron_index] * neuron[i]
						end					
						@new_values[i] += Math.tanh(sum)
					end
					
					#change stored values to the next layer's values
					@values = @new_values
				else
					#no next layer? must be output layer
					@output = @values
					layer.values = @output
				end
			end
		end
	end

	def train(input, output, iterations)
		@input = input
		iterations.times do
			feed_forward
			backpropogate(output, 0.5)
			printf "%.4f, %.4f, %.4f\n" % @output
		end
	end

	def backpropogate(desired_output, n)
		#calculate output error
		output_deltas = Array.new(@output.size)
		@output.each_index do |i|
			error = desired_output[i] - @output[i]
			output_deltas[i] = dtanh(@output[i]) * error
		end

		#calculate hidden layer error, do this for each hidden layer
		hidden_deltas = Array.new
		@layers.each_with_index do |layer, layer_index|
			#hidden layers will be all the layers in the middle
			if layer_index > 0 && layer_index < @layers.size - 1
				values = layer.values
				values.size.times do
					hidden_deltas << 0.0
				end
				layer.neurons.each_with_index do |neuron, neuron_index|
					error = 0.0
					neuron.each_with_index do |weight, weight_index|
						error = error + output_deltas[weight_index] * weight
					end
					hidden_deltas[neuron_index] = dtanh(values[neuron_index]) * error
				end
			end
		end

		#binding.pry

		#update ouput weights
		@layers[1].neurons.each_with_index do |neuron, neuron_index|
			@output.each_index do |i|
				change = output_deltas[i]*@layers[1].values[neuron_index]
				@layers[1].neurons[neuron_index][i] += n * change
			end
		end

		#update input weights
		@input.each_with_index do |input, input_index|
			@layers[1].neurons.each_with_index do |neuron, neuron_index|
				change = hidden_deltas[neuron_index]*input
				@layers[0].neurons[input_index][neuron_index] += n * change
			end
		end
	
	end

	def dtanh(y)
		return 1.0-y*y
	end
		
end