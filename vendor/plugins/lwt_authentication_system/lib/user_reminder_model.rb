if( UserReminder rescue true )
  class ::UserReminder < ActiveRecord::Base
  end
end

UserReminder.class_eval do
  belongs_to :user
  
  validates_uniqueness_of :token

  def self.create_for_user user, expires_at = Time.now + 2.hours
    create :user_id => user.id, :token => generate_token, :expires_at => expires_at
  end
  
private

  def self.generate_token
    require 'md5'
    MD5.hexdigest( rand.to_s )
  end
end
