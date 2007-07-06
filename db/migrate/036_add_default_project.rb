class AddDefaultProject < ActiveRecord::Migration
  class Project < ActiveRecord::Base ; end

  class ProjectPermission < ActiveRecord::Base
    belongs_to :project
  end

  class User < ActiveRecord::Base
    has_many :projects, :through => :project_permissions
    has_many :project_permissions, :foreign_key => "accessor_id", :as => :accessor
  end
  
  def self.up
    if Project.count == 0
      project = Project.create! :name=>"Example Project"
      User.find_by_username("admin").projects << project
    end
  end

  def self.down
    Project.destroy_all "name='Example Project'"
  end
end
