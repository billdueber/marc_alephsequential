require_relative 'asline'
require_relative 'error'
require_relative 'log'


module MARC
  module AlephSequential
    
    class ASLineGroup
      
      include MARC::AlephSequential::Log
      
      attr_accessor :fields
      attr_reader   :leader
      
      def initialize
        @fields = []
        @leader = nil
      end
      
      def size
        @fields.size
      end
      
      def empty?
        @fields.empty?
      end
      
      def add(asline)
        case asline.type
        when :leader
          if leader
            log.warn("#{asline.line_number} #{asline.id} Set leader more than once; last one wins")
          end
          @leader = asline.value
          log.debug "#{asline.line_number} #{asline.id} Set leader to #{leader}"
        when :invalid_id
          lastfield = @fields.pop
          unless lastfield
            raise MARC::AlephSequential::Error.new('unknown', asline.line_number),  
                  "#{asline.line_number} has invalid id and no preivous line to concat it to (file starts bad?)"
                  nil
          end
          log.info "#{asline.line_number} #{lastfield.id} / #{lastfield.tag} Concatenating line #{asline.line_number} to previous line"
          @fields.push ASLine.new(lastfield.rawstr + asline.rawstr, lastfield.line_number)
        else
          @fields.push asline
        end
      end
      
      def as_record
        r = MARC::Record.new
        r.leader = leader
        fields.map {|f| r << f.to_field}
        return r
      end
      
      alias_method :to_record, :as_record
    end
  end
end
          
