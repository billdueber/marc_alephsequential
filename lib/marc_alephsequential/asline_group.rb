require_relative 'asline'
require_relative 'error'
require_relative 'log'


module MARC
  module AlephSequential
    
    # A group of ASLine objects with logic to correctly turn them into a MARC::Record object
    # @see ASLine
    
    class ASLineGroup
      
      include MARC::AlephSequential::Log
      
      # @!attribute aslines
      #   @return [Array<MARC::Field>] Internal list of MARC field object
      attr_accessor :aslines
      
      # @!attribute [r] leader
      #   @return [String] The leader string, pulled from whatever was passed in with a LDR tag
      attr_reader   :leader
      
      
      
      def initialize
        @aslines = []
        @leader = nil
      end
      
      # Number of aslines already added
      # @return Integer
      def size
        aslines.size
      end
      
      # Is this group empty?
      def empty?
        aslines.empty?
      end
      
      
      # Add an ASLine object, turning it into the appropriate type of field as we go
      # An ASLine object with type :invalid_id will be treated as a string and appended to
      # the previous field (to deal with not-uncommon spurious newlines in data fields)
      # @return [Undefined] side effect only
      # @raise MARC::AlephSequential::Error when there's an invalid ID _and_ there's no previous
      # field to concatentate it to.
      
      def add(asline)
        case asline.type
        when :leader
          if leader
            log.warn("#{asline.line_number} #{asline.id} Set leader more than once; last one wins")
          end
          @leader = asline.value
          log.debug "#{asline.line_number} #{asline.id} Set leader to #{leader}"
        when :invalid_id
          lastfield = @aslines.pop
          unless lastfield
            raise MARC::AlephSequential::Error.new('unknown', asline.line_number),  
                  "#{asline.line_number} has invalid id and no preivous line to concat it to (file starts bad?)"
                  nil
          end
          log.info "#{asline.line_number} #{lastfield.id} / #{lastfield.tag} Concatenating line #{asline.line_number} to previous line"
          @aslines.push ASLine.new(lastfield.rawstr +  asline.rawstr, lastfield.line_number)
        else
          @aslines.push asline
        end
      end
      
      
      # Add an asline as a raw string
      def add_string(asline_string, line_number)
        self.add(ASLine.new(asline_string, line_number))
      end
      
      # Turn this object into a MARC::Record
      # @return [MARC::Record]
      # @raise MARC::AlephSequential::Error if this object is empty
      # @raise MARC::AlephSequential::Error if there's no leader
      def as_record
        if empty?
          raise MARC::AlephSequential::Error.new('unknown', 'unknown'), "Can't turn an empty group into a record", nil
        end
        
        unless leader
          raise MARC::AlephSequential::Error.new(@aslines[0].id, @aslines[0].line_number),
                "Record #{@aslines[0].id} (near line #{ @aslines[0].line_number}) has no leader; can't turn into a record",
                nil
        end
        r = MARC::Record.new
        r.leader = leader
        aslines.map {|f| r << f.to_field}
        return r
      end
      
      alias_method :to_record, :as_record
    end
  end
end
          
