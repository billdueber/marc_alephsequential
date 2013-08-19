module MARC
  module AlephSequential
    
    module Log
    
      def self.log
        @log
      end
    
      def self.log=(log)
        @log = log
      end
    
      def log
        Log.log ||= Yell.new STDERR, :level => [ :warn, :error], :name=>'MAS'
        Log.log
      end
    end
  end
end