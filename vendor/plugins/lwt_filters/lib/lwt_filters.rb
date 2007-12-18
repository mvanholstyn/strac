class ActionController::Base
  class << self
    alias condition_hash_before_lwt_filters condition_hash
    def condition_hash(filters, *actions)
      if actions.first.is_a? Hash
        actions = actions.first
        filters.inject({}) { |h,f| h.update( f => (actions.blank? ? nil : actions)) }
      else
        condition_hash_before_lwt_filters( filters, *actions )
      end
    end

    alias filter_excluded_from_action_before_lwt_filters? filter_excluded_from_action?
    def filter_excluded_from_action?( filter, action )
      if excluded_actions[filter].is_a? Hash
        ([excluded_actions[filter][controller_name.to_sym]] || []).flatten.include?(action.to_sym)
      else
        filter_excluded_from_action_before_lwt_filters?( filter, action )
      end
    end
  end
end
