require_relative 'similarityMetric'

class SimpleMatchingCoefficient < SimilarityMetric

	def similarity
		@similarity = 0.0
		@person1.keys.each do |key|
			@similarity += 1 if @person1[key] == @person2[key]
		end

		if @person1.keys.length > @person2.keys.length
			n = @person1.keys.length
		else
			n = @person2.keys.length
		end
		
		smc = @similarity / n
	end

end