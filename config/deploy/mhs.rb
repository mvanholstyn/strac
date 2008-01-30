set :application, "strac"
set :repository, "http://rails.lotswholetime.com/svn/#{application}/#{repository_path}"

role :web, "strac.mutuallyhuman.com"
role :app, "strac.mutuallyhuman.com"
role :db, "strac.mutuallyhuman.com", :primary => true

set(:rails_env, :production)
