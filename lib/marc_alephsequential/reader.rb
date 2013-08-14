require 'marc'
require 'yell'
require 'marc_alephsequential/asline'

module MARC
  module AlephSequential
    
    class Reader
      
      include Enumerable
      
      attr_accessor :log
      attr_reader :lines
      
      
      def initialize(file)
        if file.is_a?(String)
          handle = File.new(file)
        elsif file.respond_to?("read", 5)
          handle = file
        else
          throw "must pass in path or File/IO object"
        end
        @handle = handle
        @lines = handle.each_line # get an iterator
      end
      
      
      
      
      # Iterator
      def each
        unless block_given? 
          return enum_for(:each)
        end
        
        # The current lines
        curlines = []
        
        
        
      end


    end
  end
end
      
        
      
      
      
      
      
      
      