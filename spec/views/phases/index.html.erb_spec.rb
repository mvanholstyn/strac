require File.dirname(__FILE__) + '/../../spec_helper'

describe "/phases/index.html.erb" do
  
  before do
    render "/phases/index.html.erb"
  end

  it "renders the phases list" do
    response.should have_tag('#phases')
  end
end

