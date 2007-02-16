module ActiveRecord
  module Acts #:nodoc:
    module Taggable #:nodoc:
      def self.included(base)
        base.extend(ClassMethods)  
      end
      
      module ClassMethods
        def acts_as_taggable(options = {})
          has_many :taggings, :as => :taggable, :dependent => :destroy, :include => :tag
          has_many :tags, :through => :taggings
          
          after_save :save_tags
          
          include ActiveRecord::Acts::Taggable::InstanceMethods
          extend ActiveRecord::Acts::Taggable::SingletonMethods
          
          alias_method :reload_without_tag_list, :reload
          alias_method :reload, :reload_with_tag_list
        end
      end
      
      module SingletonMethods
        # Pass either a tag string, or an array of strings or tags
        def find_tagged_with(tags, options = {})
          tags = Tag.parse(tags) if tags.is_a?(String)
          return [] if tags.empty?
          tags.map!(&:to_s)
          
          conditions = sanitize_sql(['tags.name IN (?)', tags])
          conditions << " AND #{sanitize_sql(options.delete(:conditions))}" if options[:conditions]
          
          group = "taggings.taggable_id HAVING COUNT(taggings.taggable_id) = #{tags.size}" if options.delete(:match_all)
          
          find(:all, { :select => "DISTINCT #{table_name}.*",
            :joins => "LEFT OUTER JOIN taggings ON taggings.taggable_id = #{table_name}.#{primary_key} AND taggings.taggable_type = '#{name}' " +
                      "LEFT OUTER JOIN tags ON tags.id = taggings.tag_id",
            :conditions => conditions,
            :group      => group }.merge(options))
        end
        
        # Options:
        #  :start_at - Restrict the tags to those created after a certain time
        #  :end_at - Restrict the tags to those created before a certain time
        #  :conditions - A piece of SQL conditions to add to the query
        #  :limit - The maximum number of tags to return
        #  :order - A piece of SQL to order by. Eg 'tags.count desc' or 'taggings.created_at desc'
        #  :at_least - Exclude tags with a frequency less than the given value
        #  :at_most - Exclude tags with a frequency greater then the given value
        def tag_counts(options = {})
          options.assert_valid_keys :start_at, :end_at, :conditions, :at_least, :at_most, :order, :limit
          
          start_at = sanitize_sql(['taggings.created_at >= ?', options[:start_at]]) if options[:start_at]
          end_at = sanitize_sql(['taggings.created_at <= ?', options[:end_at]]) if options[:end_at]
          options[:conditions] = sanitize_sql(options[:conditions]) if options[:conditions]
          
          conditions = [options[:conditions], start_at, end_at].compact.join(' and ')
          
          at_least = sanitize_sql(['count >= ?', options[:at_least]]) if options[:at_least]
          at_most = sanitize_sql(['count <= ?', options[:at_most]]) if options[:at_most]
          having = [at_least, at_most].compact.join(' and ')
          
          order = "order by #{options[:order]}" if options[:order]
          limit = sanitize_sql(['limit ?', options[:limit]]) if options[:limit]
          
          Tag.find_by_sql <<-END
            select tags.id, tags.name, count(*) as count
            from tags left outer join taggings on tags.id = taggings.tag_id
                      left outer join #{table_name} on #{table_name}.id = taggings.taggable_id
            where taggings.taggable_type = "#{name}"
              #{"and #{conditions}" unless conditions.blank?}
            group by tags.id
            having count(*) > 0 #{"and #{having}" unless having.blank?}
            #{order}
            #{limit}
          END
        end
      end
      
      module InstanceMethods
        attr_writer :tag_list
        
        def tag_list
          defined?(@tag_list) ? @tag_list : read_tags
        end
        
        def save_tags
          if defined?(@tag_list)
            write_tags(@tag_list)
            remove_tag_list
          end
        end
        
        def write_tags(list)
          new_tag_names = Tag.parse(list).uniq
          old_tagging_ids = []
          
          Tag.transaction do
            taggings.each do |tagging|
              index = new_tag_names.index(tagging.tag.name)
              index ? new_tag_names.delete_at(index) : old_tagging_ids << tagging.id
            end
            
            Tagging.delete_all(['id in (?)', old_tagging_ids]) if old_tagging_ids.any?
            
            # Create any new tags/taggings
            new_tag_names.each do |name|
              Tag.find_or_create_by_name(name).tag(self)
            end
            
            taggings.reset
            tags.reset
          end
          true
        end

        def read_tags
          tags.collect do |tag|
            tag.name.include?(',') ? "\"#{tag.name}\"" : tag.name
          end.join(', ')
        end
        
        def reload_with_tag_list(*args)
          remove_tag_list
          reload_without_tag_list(*args)
        end
        
       private
        def remove_tag_list
          remove_instance_variable(:@tag_list) if defined?(@tag_list)
        end
      end
    end
  end
end

ActiveRecord::Base.send(:include, ActiveRecord::Acts::Taggable)
