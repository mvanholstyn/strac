require File.dirname(__FILE__) + '/../spec_helper'

describe RemoteSiteRenderer do
  def remote_site_renderer
    RemoteSiteRenderer.new :page => @page
  end
  
  before do
    @page_element = stub("remote page element", :replace => nil, :replace_html => nil, :hide => nil, :show => nil)
    @page = stub("remote page", :[] => @page_element, :visual_effect => nil, :delay => nil)
  end
  
  describe '#render_error' do
    def render_error
      remote_site_renderer.render_error @msg
    end
    
    before do
      @msg = "Danger Will Robinson!"
    end
    
    it "finds and replaces the error element with the passed in message" do
      @page.should_receive(:[]).with(:error).at_least(1).times.and_return(@page_element)
      @page_element.should_receive(:replace_html).with(@msg)
      render_error
    end
    
    it "hides the notice element" do
      @page.should_receive(:[]).with(:notice).and_return(@page_element)
      @page_element.should_receive(:hide)
      render_error      
    end
    
    it "shows the error element" do
      @page.should_receive(:[]).with(:error).at_least(1).times.and_return(@page_element)
      @page_element.should_receive(:show)      
      render_error
    end
    
    it "adds a visual effect on the appearance of the error element" do
      @page.should_receive(:visual_effect).with(:appear, :error)
      render_error
    end
  end
  
  describe '#render_notice' do
    def render_notice
      remote_site_renderer.render_notice @msg
    end
    
    before do
      @msg = "Woohoo!"
    end
    
    it "finds and replaces the notice element with the passed in message" do
      @page.should_receive(:[]).with(:notice).at_least(1).times.and_return(@page_element)
      @page_element.should_receive(:replace_html).with(@msg)
      render_notice
    end
    
    it "hides the error element" do
      @page.should_receive(:[]).with(:error).and_return(@page_element)
      @page_element.should_receive(:hide)
      render_notice      
    end
    
    it "shows the notice element" do
      @page.should_receive(:[]).with(:notice).at_least(1).times.and_return(@page_element)
      @page_element.should_receive(:show)      
      render_notice
    end
    
    it "adds a visual effect on the appearance of the notice element" do
      @page.should_receive(:visual_effect).with(:appear, :notice)
      render_notice
    end
    
    it "adds a 5 second delay and then fades the notice element out" do
      @page.should_receive(:visual_effect).with(:fade, :notice)
      @page.should_receive(:delay).with(5).and_yield
      render_notice
    end
  end
  
end

__END__
  def render_notice(msg)
      page.delay(5) { page.visual_effect :fade, :notice }
  end
