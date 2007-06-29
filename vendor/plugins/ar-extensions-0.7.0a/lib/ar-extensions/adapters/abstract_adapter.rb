module ActiveRecord # :nodoc:
  module ConnectionAdapters # :nodoc:
    class AbstractAdapter # :nodoc:
      NO_MAX_PACKET = 0
      QUERY_OVERHEAD = 8 #This was shown to be true for MySQL, but it's not clear where the overhead is from.
      
      # +sql+ can be a single string or an array. If it is an array all 
      # elements that are in position >= 1 will be appended to the final SQL.
      def insert_many( sql, values, *args ) # :nodoc:
        # the number of inserts default
        number_of_inserts = 0
        
        base_sql,post_sql = if sql.is_a?( String )
          [ sql, '' ]
        elsif sql.is_a?( Array )
          [ sql.shift, sql.join( ' ' ) ]
        end
        
        sql_size = QUERY_OVERHEAD + base_sql.size + post_sql.size 

        # the number of bytes the requested insert statement values will take up
        values_in_bytes = self.class.sum_sizes( *values )
        
        # the number of bytes (commas) it will take to comma separate our values
        comma_separated_bytes = values.size-1
        
        # the total number of bytes required if this statement is one statement
        total_bytes = sql_size + values_in_bytes + comma_separated_bytes
        
        max = max_allowed_packet
        
        # if we can insert it all as one statement
        if NO_MAX_PACKET == max or total_bytes < max
          number_of_inserts += 1
          sql2insert = base_sql + values.join( ',' ) + post_sql
          insert( sql2insert, *args )
        else
          value_sets = self.class.get_insert_value_sets( values, sql_size, max )
          value_sets.each do |values|
            number_of_inserts += 1
            sql2insert = base_sql + values.join( ',' ) + post_sql
            insert( sql2insert, *args )
          end
        end        

        number_of_inserts
      end
      
      # Synchronizes the passed in ActiveRecord instances with the records in
      # the database by calling +reload+ on each instance.
      def after_import_synchronize( instances )
        instances.each { |e| e.reload }
      end

      # Returns the sum of the sizes of the passed in objects. This should
      # probably be moved outside this class, but to where?
      def self.sum_sizes( *objects ) # :nodoc:
        objects.inject( 0 ){|sum,o| sum += o.size }
      end
            
      # Returns the maximum number of bytes that the server will allow
      # in a single packet
      def max_allowed_packet
        NO_MAX_PACKET
      end
      
      def self.get_insert_value_sets( values, sql_size, max_bytes ) # :nodoc:
        value_sets = []          
        arr, current_arr_values_size, current_size = [], 0, 0
        values.each_with_index do |val,i|
          comma_bytes = arr.size
          sql_size_thus_far = sql_size + current_size + val.size + comma_bytes
          if NO_MAX_PACKET == max_bytes or sql_size_thus_far <= max_bytes
            current_size += val.size            
            arr << val
          else
            value_sets << arr
            arr = [ val ]
            current_size = val.size
          end
          
          # if we're on the last iteration push whatever we have in arr to value_sets
          value_sets << arr if i == (values.size-1)
        end
        [ *value_sets ]
      end     
    
    end
  end
end
