require File.dirname(__FILE__) + '/../spec_helper'

describe Phase do
  it "belongs to a Project" do
    assert_association Phase, :belongs_to, :project, Project
  end

  it "requires a name" do
    assert_validates_presence_of Phase.new, :name
  end
  
end
