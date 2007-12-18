__END__

    
	
#	def after_save
#	    preferences.each_value do |up|
#	       raise 'Error saving preference' unless up.save
#	    end
#	end
	
#	def preferences
#	   @preferences ||= Preferences.new( self )
#	end
#	
		
#	class Preferences
#	   def initialize( user )
#  	       @user = user
#  	       #defaults
#  	       @preferences = { 
#  	         :results_per_page => UserPreference.new( :user_id => user.id, :name => 'results_per_page', :value => 5 ),
#  	         :ordering_interface => UserPreference.new( :user_id => user.id, :name => 'ordering_interface', :value => 'dragging' ),
#  	         :login_page => UserPreference.new( :user_id => user.id, :name => 'login_page', :value => '/project/summary' ),
#  	         :project_search_result_interface => UserPreference.new( :user_id => user.id, :name => 'project_search_result_interface', :value => ( user.is_manager? ? 'mini_project' : 'collapsed' ) )
#  	       }
#	       user.user_preferences.each do |preference|
#                @preferences[preference.name.to_sym] = preference
#	       end
#	   end
#	   
#	   def each_value( &blk )
#	       @preferences.each_value( &blk )
#	   end
#	   
#	   def []( sym )
#           @preferences[sym.to_sym] ? @preferences[sym.to_sym].value : ''
#	   end
#	   
#	   def []=( sym, value )
#           @preferences[sym.to_sym] ||= UserPreference.new :user_id => @user.id, :name => sym
#	       @preferences[sym.to_sym].value = value
#	   end
#	end
	