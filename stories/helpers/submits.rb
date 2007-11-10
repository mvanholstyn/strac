def submit_signup_form
  submit_form "signup" do |form|
    form.user.email_address = "chrisrittersdorf@gmail.com"
    form.user.password = "secret"
    form.user.password_confirmation = "secret"
  end
  follow_redirect!
end
