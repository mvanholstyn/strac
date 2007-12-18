if( UserReminderMailer rescue true )
  class ::UserReminderMailer < ActionMailer::Base
  end
end

UserReminderMailer.class_eval do
  def reminder( user, reminder, url, options = {} )
    recipients user.email_address
    from options[:from]
    subject options[:subject]
    body :user => user, :reminder => reminder, :url => url
  end
  
  def signup( user, reminder, url, options = {} )
    recipients user.email_address
    from options[:from]
    subject options[:subject]
    body :user => user, :reminder => reminder, :url => url
  end
end