require 'irb'

module IRB # :nodoc:
  module ExtendCommand # :nodoc:
    class Continue # :nodoc:
      def self.execute(conf)
        throw :IRB_EXIT, :cont
      end
    end
  end
  ExtendCommandBundle.def_extend_command "cont", :Continue
  
  def self.start_session(binding)
    unless @__initialized
      args = ARGV
      ARGV.replace(ARGV.dup)
      IRB.setup(nil)
      ARGV.replace(args)
      @__initialized = true
    end
    
    workspace = WorkSpace.new(binding)

    irb = Irb.new(workspace)

    @CONF[:IRB_RC].call(irb.context) if @CONF[:IRB_RC]
    @CONF[:MAIN_CONTEXT] = irb.context

    catch(:IRB_EXIT) do
      irb.eval_input
    end
  end
end

module Debugger
  class IRBCommand < Command # :nodoc:

    register_setting_get(:autoirb) do 
      IRBCommand.always_run
    end
    register_setting_set(:autoirb) do |value|
      IRBCommand.always_run = value
    end

    def regexp
      /^irb$/
    end
    
    def execute
      unless @state.interface.kind_of?(LocalInterface)
        print "Command is available only in local mode.\n"
        throw :debug_error
      end

      save_trap = trap("SIGINT") do
        throw :IRB_EXIT, :cont if $debug_in_irb
      end

      $debug_in_irb = true
      cont = IRB.start_session(get_binding)
      @state.proceed if cont == :cont
    ensure
      $debug_in_irb = false
      trap("SIGINT", save_trap) if save_trap
    end
    
    class << self
      def help_command
        'irb'
      end

      def help(cmd)
        %{
          irb\tstarts an IRB session. (EXPERIMENTAL)
        }
      end
    end
  end
end

