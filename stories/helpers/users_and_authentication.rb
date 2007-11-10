def login_as(email, password)
  submit_form 'login_form' do |form|
    form.user.email_address = email
    form.user.password = password
  end
end
