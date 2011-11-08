class Layer
	attr_reader :neurons
	attr_accessor :values

	#initialize with number of neurons in this layer - x
	#and number of neurons in next layer - y
	def initialize(x, y)
		@neurons = Array.new
		x.times do
			neuron = Array.new(y)
			
			#create random weights
			neuron.each_index do |weight|
				neuron[weight] = rand * 2.0 - 1.0
			end
			@neurons << neuron
		end
	end

end