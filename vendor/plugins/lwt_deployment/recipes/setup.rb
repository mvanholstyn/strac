after "deploy:setup", "db:configure"
after "deploy:setup", "mongrel:cluster:configure"
after "deploy:setup", "apache:configure"

# * create database
# * create logrotate
# * create deploy_to (as root)