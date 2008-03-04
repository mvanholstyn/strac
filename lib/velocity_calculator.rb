class VelocityCalculator
  ALPHA = 0.5
  
  # This uses the Karn & Patridge SRTT algorithm. http://www.opalsoft.net/qos/TCP-10.htm
  def self.compute_weighted_average(points, alpha=ALPHA)
    return 0 if points.empty?
    points[1..-1].inject(points[0]) do |t, p|
      (alpha * p) + (1-alpha) * t
    end
  end
  
end

