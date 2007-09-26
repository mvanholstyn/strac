class Generate
  
  def self.activity(action, attributes={})
    raise ArgumentError, "requires actor and affected" unless attributes[:actor] && attributes[:affected]
    attributes[:actor] = Generate.user(attributes[:actor]) unless attributes[:actor].is_a?(ActiveRecord::Base)
    Activity.create!(attributes.merge(:action=>action))
  end
  
  def self.company(name, attributes={})
    Company.create!(attributes.merge(:name=>name))
  end
  
  def self.group(name, attributes={})
    Group.create!(attributes.merge(:name=>name))
  end
  
  def self.privilege(name, attributes={})
    Privilege.create!(attributes.merge(:name=>name))
  end
  
  def self.project(name, attributes={})
    Project.create!(attributes.merge(:name=>name))
  end
  
  def self.story(summary, attributes={})
    if attributes[:project].nil?
      attributes[:project] = Generate.project("Project for #{summary}")
    end
    Story.create!(attributes.merge(:summary => summary))
  end
  
  def self.time_entry(hours, date, attributes={})
    TimeEntry.create!(attributes.merge(:hours => hours, :date => date))
  end
  
  def self.user(username, attributes={})
    if attributes[:group].nil?
      attributes[:group] = Generate.group("some group")
    elsif ! attributes[:group].is_a?(Group)
      attributes[:group] = Generate.group(attributes[:group])
    end
    
    User.create!(
      attributes.merge(
        :username => username,
        :email_address => "#{username}@#{username}.com"
      )
    )
  end
  
end