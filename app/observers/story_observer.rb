class StoryObserver < AffectedObserver
  observe Story
  
  message '"created S#{object.id}"', :created => true
  
  message '"updated points for S#{object.id}"', :updated => [ :points ]
  message '"assigned S#{object.id} to #{object.responsible_party_type.upcase}#{object.responsible_party_id}"', :updated => [ :responsible_party_id ], :nil => false
  message '"released S#{object.id} from #{differences[:responsible_party_type].last.upcase}#{differences[:responsible_party_id].last}"', :updated => [ :responsible_party_id ], :nil => true
  message '"marked S#{object.id} as STATUS#{object.status_id}"', :updated => [ :status_id ]
  message '"marked S#{object.id} as PRIORITY#{object.priority_id} priority"', :updated => [ :priority_id ]
  message '"moved S#{object.id} to I#{object.bucket_id}"', :updated => [ :bucket_id ], :nil => false 
  message '"moved S#{object.id} to the backlog"', :updated => [ :bucket_id ], :nil => true
  message '"updated S#{object.id}"', :updated => [ :summary, :description, :tag ] 

  message '"destroyed S#{object.id}"', :destroyed => true
end