namespace :piston do
  desc "Runs piston update for rails, lwt_filters, lwt_deployment and lwt_authentication_system"
  task :update do
    Dir.chdir RAILS_ROOT + "/vendor"
    system("piston up rails")
    
    Dir.chdir "plugins"
    system("piston up lwt_filters lwt_deployment lwt_authentication_system")
  end
end