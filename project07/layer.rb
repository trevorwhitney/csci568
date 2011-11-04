class Layer
	attr_reader :neurons

	#initialize with number of neurons in this layer - x
	#and number of neurons in next layer - y
	def initialize(x, y)
		x.times do
			neuron = Array.new(y)
			
			#create random weights
			neuron.each_index do |weight|
				neuron[weight] = rand * 2 - 1
			end
			@neurons << neuron
		end
	end

end