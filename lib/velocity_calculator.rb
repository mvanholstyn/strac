class VelocityCalculator
  ALPHA = 0.5
  
  def self.compute_weighted_average(values, alpha=ALPHA)
    return 0 if values.empty?
    values[1..-1].inject(values[0]) do |t, p|
      alpha * t + (1-alpha) * p 
    end
  end
  
end