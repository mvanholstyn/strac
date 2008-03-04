require File.dirname(__FILE__) + '/../spec_helper'

describe VelocityCalculator, '.compute_weighted_average' do
  def compute_weighted_average(points, alpha)
    VelocityCalculator.compute_weighted_average(points, alpha)
  end

  before do
    @points = [10, 10, 10, 40, 35, 47, 47]
  end
  
  describe "when given an empty array of points" do
    it "returns 0" do
      compute_weighted_average([], 0.7).should == 0
    end
  end

  describe "when given an array of points" do
    it "returns the weighted average based on the given alpha" do
      alpha = 0.7
      compute_weighted_average(@points, alpha).should be_close(45.812, 0.001)
    end
  end
  
  describe "when given a alpha of 0" do
    it "returns the oldest value" do
      alpha = 0.0
      compute_weighted_average(@points, alpha).should be_close(@points.first, 0.001)      
    end
  end
  
  describe "when given an alpha of 1" do
    it "returns the most recent value" do
      alpha = 1.0
      compute_weighted_average(@points, alpha).should be_close(@points.last, 0.001)      
    end
  end
end
