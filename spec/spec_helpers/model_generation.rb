class Generate

  def self.active_user(options={})
    Generate.user options.merge(:active=>true)
  end
  
  def self.activity(options={})
    @activity_count ||= 0
    action = options[:action] || "activity #{@activity_count+=1}"
    raise ArgumentError, "requires actor and affected" unless options[:actor] && options[:affected]
    options[:actor] = Generate.user(:email_address => options[:actor]) unless options[:actor].is_a?(ActiveRecord::Base)
    Activity.create!(options.merge(:action=>action))
  end

  def self.bucket(options={})
    @bucket_count ||= 0
    name = options.delete(:name) || "Bucket #{@bucket_count+=1}"
    project_id = options.delete(:project_id) || Generate.project.id
    Bucket.create!(:name => name, :project_id => project_id)
  end
      
  def self.group(options={})
    @group_count ||= 0
    name = options[:name] || "Group #{@group_count+=1}"
    privilege = Generate.privilege(:name => "user")
    group = Group.create!(options.merge(:name=>name))
    group.privileges << privilege
    group
  end

  def self.invitation(options={})
    @invitation_count ||= 0
    recipient = options[:recipient] || "invitation_recipient#{@invitation_count+=1}@example.com"
    if options[:project].nil?
      options[:project] = Generate.project(:name => "Invitation Project")
    end
    if options[:inviter].nil?
      @inviter_count ||= 0
      options[:inviter] = Generate.user(
        :email_address => "inviter#{@inviter_count+=1}@foo.com", 
        :first_name => "Henry", 
        :last_name => "James")
    end
    
    Invitation.create!(options.reverse_merge(:recipient => recipient, :message => "Come and join!"))
  end

  def self.iteration(options={})
    @iteration_count = 0
    options[:project] ||= Generate.project :name => "Project for generated iteration #{@iteration_count+=1}"
    options[:start_date] = Date.today unless options[:start_date]
    options[:end_date] = options[:start_date] + 6.days unless options.has_key?(:end_date)
    Iteration.create!(options.merge(:name => name))
  end
  
  def self.project_permission(options)
    raise ArgumentError, "requires :project" unless options[:project]
    raise ArgumentError, "requires :accessor" unless options[:accessor]
    ProjectPermission.create! :project => options[:project], :accessor => options[:accessor]
  end
  
  def self.privilege(options={})
    raise ArgumentError, "requires :name" unless options[:name]
    Privilege.create!(options.merge(:name=>options[:name]))
  end
  
  def self.phase(options={})
    @phase_count ||= 0
    name = options[:name] || "phase #{phase_count+=1}"
    if options[:project].nil?
      options[:project] = Generate.project(:name => "Project for phase #{name}")
    end
    Phase.create!(options.merge(:name=>name))
  end
  
  def self.project(options={})
    @project_count ||= 0
    name = options[:name] || "Project #{@project_count+=1}"
    members = options.delete(:members)
    returning Project.create!(options.merge(:name=>name)) do |project|
      if members
        members.each { |member| Generate.project_permission(:project => project, :accessor => member)}
      end
    end
  end

  def self.stories(options={})
    stories = []
    options.delete(:count).times do 
      stories << Generate.story(options)
    end
    stories
  end
  
  def self.story(options={})
    @story_count ||= 0
    summary ||= options.delete(:summary) || "Summary #{@story_count+=1}"
    if options[:project].nil? 
      if options[:bucket].nil?
        options[:project] = Generate.project(:name => "Project for #{summary}")
      else
        options[:project] = options[:bucket].project
      end
    end
    Story.create!(options.merge(:summary => summary))
  end
  
  def self.time_entry(options={})
    raise ArgumentError, "requires :hours" unless options[:hours]
    raise ArgumentError, "requires :date" unless options[:date]
    TimeEntry.create!(options)
  end
  
  def self.user(options={})
    @user_count ||= 0
    email_address = options[:email_address] || "generic#{@user_count+=1}@example.com"
    if options[:group].nil?
      options[:group] = Generate.group(:name => "some group")
    elsif ! options[:group].is_a?(Group)
      options[:group] = Generate.group(:name => options[:group])
    end
    
    User.create!(
      options.merge(
        :email_address => email_address,
        :password => "password",
        :password_confirmation => "password",
        :active => true
      )
    )
  end
  
  def self.users(num)
    returning([]) do |arr|
      num.times{ arr << Generate.user }
    end
  end
  
end