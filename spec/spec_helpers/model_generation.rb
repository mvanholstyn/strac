class Generate

  def self.active_user(email, attributes={})
    user email, attributes.merge(:active=>true)
  end
  
  def self.activity(action, attributes={})
    raise ArgumentError, "requires actor and affected" unless attributes[:actor] && attributes[:affected]
    attributes[:actor] = Generate.user(attributes[:actor]) unless attributes[:actor].is_a?(ActiveRecord::Base)
    Activity.create!(attributes.merge(:action=>action))
  end

  def self.bucket(options={})
    @bucket_count ||= 0
    name = options.delete(:name) || "Bucket #{@bucket_count+=1}"
    project_id = options.delete(:project_id) || Generate.project.id
    Bucket.create!(:name => name, :project_id => project_id)
  end
      
  def self.group(name, attributes={})
    privilege = Generate.privilege("user")
    group = Group.create!(attributes.merge(:name=>name))
    
    group.privileges << privilege
    
    group
  end

  def self.invitation(recipient, attributes={})
    if attributes[:project].nil?
      attributes[:project] = Generate.project("Invitation Project")
    end
    if attributes[:inviter].nil?
      @inviter_count ||= 0
      attributes[:inviter] = Generate.user(
        "inviter#{@inviter_count+=1}@foo.com", 
        :first_name => "Henry", 
        :last_name => "James")
    end
    
    Invitation.create!(attributes.reverse_merge(:recipient => recipient, :message => "Come and join!"))
  end

  def self.iteration(name, attributes={})
    @iteration_count = 0
    attributes[:project] ||= Generate.project "Project for generated iteration #{@iteration_count+=1}"
    attributes[:start_date] = Date.today unless attributes[:start_date]
    attributes[:end_date] = attributes[:start_date] + 6.days unless attributes.has_key?(:end_date)
    Iteration.create!(attributes.merge(:name => name))
  end
  
  def self.project_permission(attributes)
    raise ArgumentError, "requires project" unless attributes[:project]
    raise ArgumentError, "requires accessor" unless attributes[:accessor]
    ProjectPermission.create! :project => attributes[:project], :accessor => attributes[:accessor]
  end
  
  def self.privilege(name, attributes={})
    Privilege.create!(attributes.merge(:name=>name))
  end
  
  def self.phase(name, attributes={})
    if attributes[:project].nil?
      attributes[:project] = Generate.project("Project for phase #{name}")
    end
    Phase.create!(attributes.merge(:name=>name))
  end
  
  def self.project(name=nil, attributes={})
    @project_count ||= 0
    name ||= "Project #{@project_count+=1}"
    members = attributes.delete(:members)
    returning Project.create!(attributes.merge(:name=>name)) do |project|
      if members
        members.each { |member| Generate.project_permission(:project => project, :accessor => member)}
      end
    end
  end

  def self.stories(attributes={})
    stories = []
    attributes.delete(:count).times do 
      stories << Generate.story(attributes)
    end
    stories
  end
  
  def self.story(attributes={})
    @story_count ||= 0
    summary ||= attributes.delete(:summary) || "Summary #{@story_count+=1}"
    if attributes[:project].nil? 
      if attributes[:bucket].nil?
        attributes[:project] = Generate.project("Project for #{summary}")
      else
        attributes[:project] = attributes[:bucket].project
      end
    end
    Story.create!(attributes.merge(:summary => summary))
  end
  
  def self.time_entry(hours, date, attributes={})
    TimeEntry.create!(attributes.merge(:hours => hours, :date => date))
  end
  
  def self.user(email_address=nil, attributes={})
    @user_count ||= 0
    email_address ||= "generic#{@user_count+=1}@example.com"
    if attributes[:group].nil?
      attributes[:group] = Generate.group("some group")
    elsif ! attributes[:group].is_a?(Group)
      attributes[:group] = Generate.group(attributes[:group])
    end
    
    User.create!(
      attributes.merge(
        :email_address => email_address,
        :password => "password",
        :password_confirmation => "password",
        :active => true
      )
    )
  end
  
end