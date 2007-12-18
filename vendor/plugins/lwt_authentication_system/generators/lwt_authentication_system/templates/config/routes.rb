map.with_options :controller => "users" do |users_map|
  users_map.login "users/login", :action => "login"
  users_map.reminder_login "users/:id/login/:token", :action => "login"
  users_map.logout "users/logout", :action => "logout"
  users_map.reminder "users/reminder", :action => "reminder"
  users_map.profile "users/profile", :action => "profile"
  users_map.signup "users/signup", :action => "signup"
end