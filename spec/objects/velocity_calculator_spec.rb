require File.dirname(__FILE__) + '/../spec_helper'

describe VelocityCalculator, '.compute_weighted_average' do
  def compute_weighted_average(points, alpha)
    VelocityCalculator.compute_weighted_average(points, alpha)
  end
  
  describe "when given no points" do
    it "returns 0" do
      compute_weighted_average([], 0.7).should == 0
    end
  end

  describe "when given an array of points" do
    it "returns the weighted average based on the given alpha" do
      alpha = 0.5
      points = [10, 10, 10, 40, 35, 47, 47]
      compute_weighted_average(points, alpha).should be_close(42.75, 0.001)
    end
  end
end
