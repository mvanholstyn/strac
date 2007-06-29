module Debugger
  class Command # :nodoc:
    class << self
      def commands
        @commands ||= []
      end
      
      DEF_OPTIONS = {
        :event => true, 
        :control => false, 
        :always_run => false,
        :unknown => false,
        :need_context => false,
      }
      
      def inherited(klass)
        DEF_OPTIONS.each do |o, v|
          klass.options[o] = v if klass.options[o].nil?
        end
        commands << klass
      end 

      def load_commands
        dir = File.dirname(__FILE__)
        Dir[File.join(dir, 'commands', '*')].each do |file|
          require file if file =~ /\.rb$/
        end
      end
      
      def method_missing(meth, *args, &block)
        if meth.to_s =~ /^(.+?)=$/
          @options[$1.intern] = args.first
        else
          if @options.has_key?(meth)
            @options[meth]
          else
            super
          end
        end
      end
      
      def options
        @options ||= {}
      end

      def settings_map
        @@settings_map ||= {}
      end
      private :settings_map
      
      def settings
        unless @settings
          @settings = Object.new
          map = settings_map
          class << @settings; self end.send(:define_method, :[]) do |name|
            raise "No such setting #{name}" unless map.has_key?(name)
            map[name][:getter].call
          end
          class << @settings; self end.send(:define_method, :[]=) do |name, value|
            raise "No such setting #{name}" unless map.has_key?(name)
            map[name][:setter].call(value)
          end
        end
        @settings
      end

      def register_setting_var(name, default)
        var_name = "@@#{name}"
        class_variable_set(var_name, default)
        register_setting_get(name) { class_variable_get(var_name) }
        register_setting_set(name) { |value| class_variable_set(var_name, value) }
      end

      def register_setting_get(name, &block)
        settings_map[name] ||= {}
        settings_map[name][:getter] = block
      end

      def register_setting_set(name, &block)
        settings_map[name] ||= {}
        settings_map[name][:setter] = block
      end
    end

    register_setting_var(:stack_trace_on_error, false)
    register_setting_var(:frame_full_path, true)
    register_setting_var(:frame_class_names, false)
    register_setting_var(:force_stepping, false)
    
    def initialize(state)
      @state = state
    end

    def match(input)
      @match = regexp.match(input)
    end

    protected

    def print(*args)
      @state.print(*args)
    end

    def confirm(msg)
      @state.confirm(msg) == 'y'
    end

    def debug_eval(str, b = get_binding)
      begin
        val = eval(str, b)
      rescue StandardError, ScriptError => e
        if Command.settings[:stack_trace_on_error]
          at = eval("caller(1)", b)
          print "%s:%s\n", at.shift, e.to_s.sub(/\(eval\):1:(in `.*?':)?/, '')
          for i in at
            print "\tfrom %s\n", i
          end
        else
          print "#{e.class} Exception: #{e.message}\n"
        end
        throw :debug_error
      end
    end

    def debug_silent_eval(str)
      begin
        eval(str, get_binding)
      rescue StandardError, ScriptError
        nil
      end
    end

    def get_binding
      @state.context.frame_binding(@state.frame_pos)
    end

    def line_at(file, line)
      Debugger.line_at(file, line)
    end

    def get_context(thnum)
      Debugger.contexts.find{|c| c.thnum == thnum}
    end  
  end
  
  Command.load_commands

  # Returns setting object.
  # Use Debugger.settings[] and Debugger.settings[]= methods to query and set
  # debugger settings. These settings are available:
  # 
  # - :autolist - automatically calls 'list' command on breakpoint
  # - :autoeval - evaluates input in the current binding if it's not recognized as a debugger command
  # - :autoirb - automatically calls 'irb' command on breakpoint
  # - :stack_trace_on_error - shows full stack trace if eval command results with an exception
  # - :frame_full_path - displays full paths when showing frame stack
  # - :frame_class_names - displays method's class name when showing frame stack
  # - :reload_source_on_change - makes 'list' command to always display up-to-date source code
  # - :force_stepping - stepping command asways move to the new line
  # 
  def self.settings
    Command.settings
  end
end
