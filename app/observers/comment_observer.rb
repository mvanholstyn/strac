class CommentObserver < AffectedObserver
  observe Comment
  
  message '"added a comment to S#{object.commenter_id}"', :created => true, :project => Proc.new{ |o| o.commenter.project }, :object => Proc.new{ |o| o.commenter }
end