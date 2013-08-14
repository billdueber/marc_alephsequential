module MARC
  module AlephSequential
    
    class Error < RuntimeError
      attr_accessor :record_id, :line_no
  
      def initialize(record_id, line_no)
        @record_id = record_id
        @line_no = line_no
      end
    end
  end
end