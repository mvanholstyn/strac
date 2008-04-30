module Selenium
  class SubProcess
    attr_accessor :pid
    
    def initialize command = nil
      @command = command
    end
    
    def start
      @pid = fork do
        # Since we can't use shell redirects without screwing up the pid, we'll reopen stdin and stdout instead to get the same effect.
        [STDOUT,STDERR].each {|f| f.reopen '/dev/null', 'w' }
        exec @command
      end
    end

    def stop
      Process.kill 15, @pid
    end
        
    def self.start(*args)
      process = new(*args)
      process.start
      process
    end
    
    def self.find(command)
      result = `ps -e -o pid,command`.split(/\s*\n\s*/).grep(/#{Regexp.escape(command)}/).first
      if result
        process = new
        process.pid = result.to_i
        process
      end
    end
  end
end