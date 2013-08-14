module MARC
  module AlephSequential
    
    class ASLine
      
      TURN_TO_SPACE = /\^/
      SPACIFY_TYPES = [:control, :leader]
      DEFAULT_LOG = Yell.new(STDERR, :level => :fatal)
      SUBFIELD_SPLIT_PATTERN = /\$\$([a-zA-Z0-9])/

      attr_accessor :line_number, :rawstr, :log, 
                    :id,  :tag, :ind1, :ind2, :type, :value
                    
      attr_reader :tag
      
      def initialize(rawstr, line_number, log=DEFAULT_LOG)
        @rawstr = rawstr
        @line_number = line_number
        @log = log
        
        (self.id,self.tag,self.ind1,self.ind2,self.value) = *(parseline(rawstr))
        
        # do error checking against the tag, id, etc.
        if SPACIFY_TYPES.include? self.type
          self.value = cleanup_fixed(self.value)
        end
        
      end
      
      
      # Turn it into an actual MARC field (control or data)
      # Throw an error if called on a leader (LDR) line
      def to_field
        case type
        when :control
          self.to_control_field
        when :data
          self.to_data_field
        else
          log.fatal "Tried to call #to_field on line type '#{self.type}'"
        end
      end
      
      def to_control_field
        MARC::ControlField.new(tag, cleanup_fixed(self.value))
      end
      
      def to_data_field
        subfields = parse_string_into_subfields(value)
        f = MARC::DataField.new(tag, ind1, ind2)
        f.subfields = subfields
        return f
      end  
      
      # Parse out a non-controlfield value string into a set of subfields
      # @param [String] val the value string, of the form "$$athis is the a$$band the b"
      # @return [Array<Subfield>] An array of MARC subfields
      #
      # If the first value in the array returned by the split isn't the empty string, then
      # the string didn't start with '$$' and we should throw a warning 
      # (and put it into an 'a' if we're running in flexible mode)
      
      def parse_string_into_subfields(val)
        sfpairs = val.split(SUBFIELD_SPLIT_PATTERN)
        initial_null_string = sfpairs.shift
        unless initial_null_string == ''
          # do something about the error
        end
        
        sfpairs.each_slice(2).map {|code, val| MARC::Subfield.new(code, val) }
        
      end
      
      # Clean up fixed fields/leader
      def cleanup_fixed(val)
        return val.gsub(TURN_TO_SPACE, ' ')
      end
        
      # Set the type when we set the tag
      def tag=(t)
        @tag = t
        if t == 'LDR'
          self.type = :leader
        elsif MARC::ControlField.control_tag?(t)
          self.type = :control
        else
          self.type = :data
        end
      end
        
        
      # Get a line and parse it out into its componant parts
      # @param [String] line the line to parse
      # @return [Array] An array of the form [id, tag, ind1, ind2, value]
      
      def parseline(line)
        id = line[0,9]
        tag = line[10,3]
        ind1 = line[13,1]
        ind2 = line[14,1]
        value = line[18..-1]
        return [id,tag,ind1,ind2,value]
      end
      
        
        
        
    end # ASLine
  end
end
    
 