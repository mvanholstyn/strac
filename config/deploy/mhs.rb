set :application, "strac"
set :repository, "git://github.com/mvanholstyn/strac.git"
set :scm, :git
set :deploy_via, :remote_cache 
set :rails_env, :production

role :web, "strac.mutuallyhuman.com"
role :app, "strac.mutuallyhuman.com"
role :db, "strac.mutuallyhuman.com", :primary => true

