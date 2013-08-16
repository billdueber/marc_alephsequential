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
          # log.warn "Set leader for #{asline.id} twice" if leader
          leader = asline.value
        when :invalid_id
          lastfield = @fields.pop
          unless lastfield
            raise MARC::AlephSequential::Error.new('unknown', asline.line_number),  
                  "Line #{asline.line_number} has invalid id and no preivous line to concat it to"
                  nil
            end
            # log.info "Concatenating line #{asline.line_number} to previous line (#{lastfield.id} / #{lastfield.tag})"
            @fields.push ASLine.new(lastfield.rawstr + asline.rawstr).to_field
          end
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
          
