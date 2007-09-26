# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

# OverrideRakeTask - taken from http://www.taknado.com/2007/7/30/overriding-rake-tasks
Rake::TaskManager.class_eval do
  def remove_task(task_name)
    @tasks.delete(task_name.to_s)
  end
end
 
def remove_task(task_name)
  Rake.application.remove_task(task_name)
end

def override_task(args, &block)
  name, deps = Rake.application.resolve_args(args)  
  remove_task Rake.application[name].name
  task(args, &block)
end

Rake.application.remove_task(:default)
task :default => :spec