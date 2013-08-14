require 'marc'
require 'yell'
require 'marc_alephsequential/asline'

module MARC
  module AlephSequential
    
    class Reader
      
      include Enumerable
      
      attr_accessor :log
      attr_reader :lines
      attr_accessor :current_id
      
      
      def initialize(file_or_string)
        @handle = MARC::AlephSequential::BufferedLineReader(file_or_string)
      end
      
      
      
      
      # Iterator
      def each
        unless block_given? 
          return enum_for(:each)
        end
                
        
        
        
      end


    end
  end
end
      
        
      
      
      
      
      
      
      