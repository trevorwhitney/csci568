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
		deltas = Array.new

		#calculate output error
		output_deltas = Array.new(@output.size)
		@output.each_index do |i|
			error = desired_output[i] - @output[i]
			output_deltas[i] = dtanh(@output[i]) * error
		end

		#calculate hidden layer error, do this for each hidden layer
		@layers.each_with_index do |layer, layer_index|
			#hidden layers will be all the layers in the middle
			if layer_index > 0 && layer_index < @layers.size - 1
				values = layer.values
				hidden_deltas = Array.new(values.size)
				layer.neurons.each_with_index do |neuron, neuron_index|
					error = 0.0
					neuron.each_with_index do |weight, weight_index|
						error = error + output_deltas[weight_index] * weight
					end
					hidden_deltas[neuron_index] = dtanh(values[neuron_index]) * error
				end
				#add current hidden layer's deltas to the master array
				deltas << hidden_deltas
			end
		end

		#output output_deltas to the end of master array
		deltas << output_deltas

		#binding.pry

		#update weights
		@layers.each_with_index do |layer, layer_index|
			if layer_index < @layers.size - 1
				layer_deltas = deltas[layer_index]
				layer.neurons.each_with_index do |neuron, neuron_index|
					neuron.each_with_index do |weight, weight_index|
						change = layer_deltas[weight_index] * layer.values[neuron_index]
						layer.neurons[neuron_index][weight_index] = weight * n * change
					end
				end
			end
		end
	end

	def dtanh(y)
		return 1.0 - y * y
	end
		
end