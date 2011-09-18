require_relative 'similarityMetric'

class PearsonCorrelation < SimilarityMetric

	def similarity
		@similarity = @person1.keys & @person2.keys
		if @similarity.empty?
			return 0
		end

		sum1, sum2, sum1Sq, sum2Sq, productSum = 0, 0, 0, 0, 0
		@similarity.each do |movie|
			sum1 += @person1[movie]
			sum2 += @person2[movie]
			sum1Sq += @person1[movie]**2
			sum2Sq += @person2[movie]**2
			productSum += @person1[movie]*@person2[movie]
		end

		#Pearson score
		numerator = productSum - (sum1*sum2/@similarity.length)
		denomenator = Math.sqrt((sum1Sq-(sum1**2)/@similarity.length)*(sum2Sq-(sum2**2)/@similarity.length))
		return 0 if denomenator == 0

		r = numerator/denomenator
	end

end