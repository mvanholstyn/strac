class LwtDeploymentGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.directory 'config'
      m.template 'config/deploy.rb', 'config/deploy.rb'
    end
  end
end
