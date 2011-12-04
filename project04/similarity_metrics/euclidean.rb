require_relative 'similarityMetric'

class EuclideanDistance < SimilarityMetric

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

    euc = 1 / (1 + Math.sqrt(@sim))
  end

end