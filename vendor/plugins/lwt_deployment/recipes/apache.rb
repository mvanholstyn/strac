namespace :apache do
  task :configure do
    require 'erb'
    run "umask 02 && mkdir -p #{shared_path}/config"
    template = File.read(File.join(File.dirname(__FILE__), "..", "templates", "config", "virtual_host.conf"))
    result = ERB.new(template).result(binding)
    put result, "#{shared_path}/config/virtual_host.conf", :mode => 0644
    # sudo "rm -f /etc/apache2/sites-enabled/#{application}-#{rails_env}.conf && ln -s #{shared_path}/config/virtual_host.conf /etc/apache2/sites-enabled/#{application}-#{rails_env}.conf"
  end
end
