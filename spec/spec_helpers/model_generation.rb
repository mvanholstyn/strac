class Generate
  
  def self.company(name, attributes={})
    Company.create!(attributes.merge(:name=>name))
  end
  
  def self.group(name, attributes={})
    Group.create!(attributes.merge(:name=>name))
  end
  
  def self.project(name, attributes={})
    Project.create!(attributes.merge(:name=>name))
  end
  
  def self.user(username, attributes={})
    raise ArgumentError, "requires group" unless attributes.has_key?(:group)
    User.create!(
      attributes.merge(
        :username => username,
        :email_address => "#{username}@#{username}.com"
      )
    )
  end
  
end