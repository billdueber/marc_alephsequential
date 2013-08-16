require 'marc'
require 'yell'
require 'marc_alephsequential/asline_reader'

module MARC
  module AlephSequential
    
    class Reader
      
      include Enumerable
      
      attr_accessor :log
      attr_reader :lines
      attr_accessor :current_id
      
      def initialize(filename_or_io, opts={})
        @areader = ASLineReader.new(filename_or_io)
      end
      
      
      
      
      


    end
  end
end
      
        
      
      
      
      
      
      
      