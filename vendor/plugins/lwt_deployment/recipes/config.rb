require 'etc'
# Load the mongrel_cluster tasks
require 'mongrel_cluster/recipes'

# You must set :repository_path and :application in your Capfile

# Sets the RAILS_ENV for this deployment. Default: staging
set(:rails_env, ENV["RAILS_ENV"] ? ENV["RAILS_ENV"].to_sym : :staging)

# Sets the environment for the mongrel cluster
set(:mongrel_environment) { rails_env }

# Sets the location to deploy from. Default: trunk
if tag = ENV["TAG"]
  set(:repository_path, "tags/#{tag}")
elsif branch = ENV["BRANCH"]
  set(:repository_path, "branches/#{branch}")
else
  set(:repository_path, :trunk)
end

# Sets the repository host. This MUST be set.
set(:repository_host) { abort "Please specify the host for your repository, set :repository_host, 'svn.example.com'" }

# Sets the repository to deploy from. Default: http://#{repository_host}/#{application}/#{repository_path}
set(:repository) { "http://#{repository_host}/#{application}/#{repository_path}" }

# Sets the user to deploy as. Default: #{application}
set(:user) { application }

# Sets the user to run mongrel processes as
set(:mongrel_user) { application }

# Sets the group to run mongrel processes as
set(:mongrel_group) { application }

# Sets the SCM user to deploy as. Default: #{Etc.getlogin}
set(:scm_username, Etc.getlogin)

# Prompt for SCM password
set(:scm_prefer_prompt, true)

# Sets the location to deploy to. Default: /var/www/#{application}/#{rails_env}
set(:deploy_to) { "/var/www/#{application}/#{rails_env}" }

# Sets the extra paths to symlink.
set(:symlinks, [])

set(:backups, [])
set(:backup_on_deploy, true)

set(:use_sudo, false)

# Sets the mongrel_cluster config location. Default: #{shared_path}/config/mongrel_cluster.yml
set(:mongrel_conf) { "#{shared_path}/config/mongrel_cluster.yml" }