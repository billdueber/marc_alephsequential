module MARC
  module AlephSequential
    
    class Error < RuntimeError
      attr_accessor :record_id, :line_number
  
      def initialize(record_id, line_number)
        @record_id = record_id
        @line_number = line_number
      end
    end
  end
end