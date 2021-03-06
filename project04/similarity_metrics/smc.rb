require_relative 'similarityMetric'

class SimpleMatchingCoefficient < SimilarityMetric

	def similarity
		similarity = 0.0
		n = 0.0

		@person1.each_index do |index|
			if @person1[index] == 0 && @person2[index] == 1
				n += 1
			elsif @person1[index] == 1 && @person2[index] == 0
				n += 1
			elsif @person1[index] == 1 && @person2[index] == 1
				similarity += 1
			elsif @person1[index] == 0 && @person2[index] == 0
				similarity += 1
			end
		end

		n += similarity
		

		smc = similarity / n
	end

end