module LwtTesting
  module Submits
    
    def submit_signup_form(opts={})
      opts.reverse_merge!(:email_address=>"chrisrittersdorf@gmail.com", :password=>"secret", :password_confirmation=>"secret")
      submit_form "signup" do |form|
        form.user.email_address = opts[:email_address]
        form.user.password = opts[:password]
        form.user.password_confirmation = opts[:password_confirmation]
      end
      follow_redirect! if response.redirected_to
    end
    
    def submit_form_by_id(id)
      submit_form id do |form|
        yield form if block_given?
      end
      follow_all_redirects
    end
    
    def submit_new_phase_form
      submit_form_by_id 'new_phase' do |form|
        form.phase.name = "FooBaz"
        form.phase.description = "Descriptisio"
        yield form if block_given?
      end 
    end
    
    def submit_new_phase_form_with_invalid_information
      submit_new_phase_form do |form|
        form.phase.name = ""
        form.phase.description = ""
      end
    end
    
    def submit_edit_phase_form(&blk)
      submit_form_by_id 'edit_form', &blk
    end
  end  
end

module Spec::Story::World
  include LwtTesting::Submits
end