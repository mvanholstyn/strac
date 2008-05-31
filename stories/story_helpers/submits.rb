module LwtTesting
  module Submits
    
    def submit_signup_form(opts={})
      opts = opts.reverse_merge(
        :email_address => "chrisrittersdorf@gmail.com", 
        :first_name => "Joe",
        :last_name => "Smoe",
        :password => "secret", 
        :password_confirmation => "secret"
      )
      submit_form "signup" do |form|
        form.user.first_name = opts[:first_name]
        form.user.last_name = opts[:last_name]
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

    def submit_new_project_form(&blk)
      submit_form_by_id 'new_project' do |form|
        form.project.name = "some project"
        yield form if block_given?
      end
    end
    
    def submit_project_form(project, &blk)
      submit_form_by_id dom_id(project, 'edit'), &blk
    end
    
    def submit_profile_form(user, &blk)
      submit_form_by_id 'user_form', &blk
    end
    
    def submit_login_form(&blk)
      submit_form_by_id 'login_form', &blk
    end

    def submit_new_invitation_form(&blk)
      submit_form_by_id 'new_invitation', &blk
    end
  end  
end

module Spec::Story::World
  include LwtTesting::Submits
end