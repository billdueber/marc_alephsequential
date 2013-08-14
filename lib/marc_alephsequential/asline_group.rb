require_relative 'asline'
require_relative 'error'


module MARC
  module AlephSequential
    
    class ASLineGroup
      
      attr_accessor :fields
      attr_reader   :leader
      
      def initailize
        @fields = []
        @leader = nil
      end
      
      
      def add(asline)
        case asline.type
        when :leader
          leader = asline.value
        when :invalid_id
          # do something smart
        else
          @fields << asline.to_field
        end
      end
      
      def as_record
        r = MARC::Record.new
        r.leader = leader
        fields.map {|f| r << f}
        return r
      end
    end
  end
end
          
