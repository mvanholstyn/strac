module RailsSeleniumStory::Helpers
  def in_dialog_scope
    in_scope dialog_selector do
      yield
    end
  end

  def dismiss_dialog
    in_dialog_scope { scoped :click, descendant(:class => 'closebox') }
  end 

  def dialog_selector
    descendant(:id => 'modal_container')
  end

  def assert_select_dialog(&blk)
    see_dialog
    assert_select '#modal_container', true, "couldn't find dialog" do
      yield
    end
  end

  def see_dialog
    assert is_visible(dialog_selector), "dialog was not visible"
  end

  def see_no_dialog
    assert !is_visible(dialog_selector), "dialog was visible"
  end
end
