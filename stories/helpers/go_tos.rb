def go_to_the_dashboard
  get dashboard_path
  follow_redirect! if response.redirect?
end
