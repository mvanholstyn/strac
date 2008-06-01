class ActiveRecord::Base
  
  # Finds the most recently created record within the last 5 seconds. If none
  # were created in the past 5 seconds then it will wait for up to 3 seconds until
  # a record is found. 
  #
  # Unfortunately Selenium execution seems to be one step ahead of the actual
  # test server processing. This method should be used if you are looking for
  # a newly created record after a Selenium based form submission.
  #
  # This can be used with a block to provide an additional condition.
  # For example, to find an Expense which was recently created with an amount of 1.99"
  #   Expense.find_newly_created { |expense| expense.amount == 1.99 }
  #
  def self.find_newly_created
    now = Time.now
    record = self.last
    c = 0
    loop do
      if Spec::Matchers::BeClose.new(now.to_i, 5.seconds).matches?(record.created_at.to_i)
        if block_given?
          break if yield(record)
        else
          break
        end
      end
      record = self.last
      sleep 2
      c+=1
      raise "the record was not created in a timely fashion" if c == 10
    end
    record
  end

  # This takes a record, reloads it and returns it after it has been updated.
  #
  # Unfortunately Selenium execution seems to be one step ahead of the actual
  # test server processing. This method should be used if you are looking for
  # a just-updated record after a Selenium based form submission. It will wait
  # up to 3 seconds for the record to be updated.
  def self.find_recently_updated(record)
    now = Time.now
    updated_at = record.updated_at
    c = 0
    loop do
      record.reload
      if block_given?
        break if yield(record)
      elsif record.updated_at != updated_at
        break
      end
      sleep 2
      c+=1
      raise "the expense was not updated in a timely fashion" if c == 10
    end
    record
  end

end
