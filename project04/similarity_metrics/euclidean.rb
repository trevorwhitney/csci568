class EuclideanDistance

	@person1 = {}
	@person2 = {}

	def initialize(person1, person2)
		@person1 = person1
		@person2 = person2
	end

	def similarity
		@similarity = @person1.keys & @person2.keys
		
		if @similarity.empty?
			return 0
		end
		
		@sim = 0
		@similarity.each do |movie|
			dif_squared = (@person1[movie] - @person2[movie])**2
			@sim += dif_squared
		end

		1 / (1 + Math.sqrt(@sim))
		
	end

end