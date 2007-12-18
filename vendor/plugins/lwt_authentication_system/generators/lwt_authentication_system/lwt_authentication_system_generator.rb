class LwtAuthenticationSystemGenerator < Rails::Generator::Base

  #TODO: update classes of they exists?
  #TODO: Add routes?
  #TODO: Add tests
  def manifest
    record do |m|
      m.directory File.join( *%w{ app controllers } )
      m.directory File.join( *%w{ app models } )
      m.directory File.join( *%w{ app views user_reminder_mailer } )
      m.directory File.join( *%w{ app views users } )
      m.directory File.join( *%w{ spec fixtures } )
      m.directory File.join( *%w{ db migrate } )

      m.template 'app/controllers/login_controller.rb', File.join( *%w{ app controllers users_controller.rb } )
      m.template 'app/models/model.rb', File.join( *%w{ app models user.rb } )
      m.template 'app/views/user_reminder_mailer/reminder.html.erb', File.join( *%W{ app views user_reminder_mailer reminder.html.erb } )
      m.template 'app/views/users/login.html.erb', File.join( *%W{ app views users login.html.erb } )
      m.template 'app/views/users/profile.html.erb', File.join( *%W{ app views users profile.html.erb } )
      m.template 'app/views/users/reminder.html.erb', File.join( *%W{ app views users reminder.html.erb } )
      m.template 'app/views/users/signup.html.erb', File.join( *%W{ app views users signup.html.erb } )
      m.template 'spec/fixtures/groups.yml', File.join( *%w{ spec fixtures groups.yml } )
      m.template 'spec/fixtures/groups_privileges.yml', File.join( *%w{ spec fixtures groups_privileges.yml } )
      m.template 'spec/fixtures/privileges.yml', File.join( *%w{ spec fixtures privileges.yml } )
      m.template 'spec/fixtures/users.yml', File.join( *%w{ spec fixtures users.yml } )
      m.migration_template 'db/migrate/migration.rb', File.join( *%w{ db migrate } ), :migration_file_name => "add_lwt_authentication_system"
    end
  end
end
