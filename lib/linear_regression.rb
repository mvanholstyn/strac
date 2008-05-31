class LinearRegression

  def initialize xs, ys
    @slope = calculate_slope xs, ys
    @intercept = calculate_intercept @slope, xs, ys
  end
  
  attr_reader :slope, :intercept
  
  def [](x)
    @intercept + @slope*x
  end
  
  private
  
  def sum(arr)
    arr.inject(0.0){ |sum, x|
      sum + x
    }
  end
  
  def sum_products(xs, ys)
    xs.zip(ys).inject(0.0){|result, (x,y)|
      result + x*y
    }
  end
  
  def sum_squares(xs)
    xs.inject(0.0) {|result, x|
      result + x*x
    }
  end
  
  def calculate_slope(xs, ys)
    n = xs.size
    (n*sum_products(xs, ys) - sum(xs)*sum(ys)) / (n*sum_squares(xs) - sum(xs)**2)
  end
  
  def calculate_intercept(m, xs,ys)
    (sum(ys) - m*sum(xs))/xs.size
  end
end