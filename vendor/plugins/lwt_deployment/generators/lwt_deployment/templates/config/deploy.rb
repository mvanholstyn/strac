set :application, "example"
set :repository_host, "svn.example.com"

role :web, "example.com"
role :app, "example.com"
role :db, "example.com", :primary => true
