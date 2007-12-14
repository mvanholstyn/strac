module CachedMethods
  def self.included klass
    super
    klass.extend ClassMethods
  end
  
  
  module ClassMethods
    def declare_cached(attr_name, &block)
      block_method_name = random_method_name(attr_name)
      define_method(block_method_name, &block)
      private block_method_name

      define_method attr_name do
        result = send block_method_name
        meta_def attr_name do
          result
        end
        result
      end
    end

    def delegate_cached(*names)
      hash = prepare_delegate_hash names
      target = hash.delete :to
      target_is_var = target.to_s =~ /^@/

      hash.each_pair do |label, value|
        declare_cached(label) do
          delegated_to = target_is_var ? instance_variable_get(target) : send(target)          
          delegated_to.send(value) if delegated_to
        end
      end
    end


    private 

    def prepare_delegate_hash(arg_list)
      hash = arg_list.last.is_a?(Hash) ? arg_list.pop : {}
      raise "need a :to parameter" unless hash[:to]

      arg_list.each do |name| 
        hash[name] = name
      end

      hash
    end

    def random_method_name(start)
      begin
        name = "#{start}_#{rand(2 ** 40).to_s(36)}"
      end until not instance_methods.include? name
      name
    end
  end
end
