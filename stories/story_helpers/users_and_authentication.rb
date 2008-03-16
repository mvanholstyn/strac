module LwtTesting
  module UsersAndAuthentication
    def login_as(email, password)
      submit_form "login_form" do |form|
        form.user.email_address = email
        form.user.password = password
      end
      follow_redirect! while response.redirect?
    end
  end
end

module Spec::Story::World
  include LwtTesting::UsersAndAuthentication
end
