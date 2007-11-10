def submit_signup_form(opts={})
  opts.reverse_merge!(:email_address=>"chrisrittersdorf@gmail.com", :password=>"secret", :password_confirmation=>"secret")
  submit_form "signup" do |form|
    form.user.email_address = opts[:email_address]
    form.user.password = opts[:password]
    form.user.password_confirmation = opts[:password_confirmation]
  end
  follow_redirect! if response.redirected_to
end
