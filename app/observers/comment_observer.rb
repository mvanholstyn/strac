class CommentObserver < AffectedObserver
  observe Comment
  
  message '"added a comment to S#{object.commentable_id}"', :created => true, :project => Proc.new{ |o| o.commentable.project }, :object => Proc.new{ |o| o.commentable }
end