require_relative 'similarityMetric'

class CosineSimilarity < SimilarityMetric

	def similarity
		dot_product = 0.0

		@person1.each_index do |index|
			dot_product += @person1[index]*@person2[index]
		end

		return 0 if dot_product == 0.0

		vector1 = 0.0
		@person1.each do |value|
			vector1 += value**2
		end

		vector2 = 0.0
		@person2.each do |value|
			vector2 += value**2
		end

		vector1Length = Math.sqrt(vector1)
		vector2Length = Math.sqrt(vector2)

		cos = dot_product / (vector1Length * vector2Length)
		
	end

end