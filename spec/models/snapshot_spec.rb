require File.dirname(__FILE__) + '/../spec_helper'

describe Snapshot do
  describe "associations" do
    it_belongs_to :bucket
  end
end