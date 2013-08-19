require 'marc'
require_relative 'error'
require_relative 'log'

module MARC
  module AlephSequential
    
    
    #  A model of a line (field) in an alephsequential file.
    class ASLine
      
      include Log

      # Characters in leader/control fields that need to be turned (back) into spaces
      TURN_TO_SPACE = /\^/

      # Pattern used to split data field values into subfield code/value pairs      
      SUBFIELD_SPLIT_PATTERN = /\$\$([a-zA-Z0-9])/
      
      # How to know if we have a valid id? Must be 9 digits
      VALID_ID = /^\d{9}$/
      
      # The passed in raw string, used for post-processing later on
      attr_accessor :rawstr
      
      # The line number in the file/stream, for error reporting
      attr_accessor :line_number
      
      # Either the value of a control/fiexed field, or a string representation of a datafield's subfield
      attr_accessor :value
      
      # The type of field (:leader, :control, :data, or :invalid_id)
      attr_accessor :type
      
      attr_accessor :id,  :tag, :ind1, :ind2

      # The MARC field's tag
      attr_reader :tag
      
      
      # Given a raw string and a line number, construct the appropriate ASLine.
      # 
      # @param [String] rawstr The raw string from the file 
      # @param [Number] line_number The line number from the file/stream, for error reporting
      
      def initialize(rawstr, line_number)
        @rawstr = rawstr.chomp
        @line_number = line_number
                
        (self.id,self.tag,self.ind1,self.ind2,self.value) = *(parseline(@rawstr))
        
        # clean up the leader or fixed fields
        if [:leader, :control].include? self.type
          self.value = cleanup_fixed(self.value)
        end
        
      end
      
      # Does this line have a valid (-looking) id? 
      def valid_id?
        return VALID_ID.match(id) ? true : false
      end
      
      
      # Turn it into an actual MARC field (control or data)
      # Throw an error if called on a leader (LDR) line
      # @return [MARC::ControlField, MARC::DataField]
      def to_field
        case type
        when :control
          self.to_control_field
        when :data
          self.to_data_field
        else
          raise MARC::AlephSequential::Error.new(id, line_number ), "Tried to call #to_field on line type '#{self.type}'", nil
        end
      end
      
      # Turn the current object into a control field, without doing any checks
      # @return [MARC::ControlField]
      def to_control_field
        MARC::ControlField.new(tag, cleanup_fixed(self.value))
      end
      
      # Turn the current object into a datafield, without doing any checks
      # @return [MARC::DataField]
      def to_data_field
        if self.value[0..1] != '$$'
          log.error("#{self.line_number} #{self.id} Variable field #{self.tag} doesn't start with '$$'. Prepending '$$a'.")
          self.value = '$$a' + self.value
        end

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
      # (and put the value into a subfield 'a' if we're running in flexible mode)
      
      def parse_string_into_subfields(val)
        sfpairs = val.split(SUBFIELD_SPLIT_PATTERN)
        initial_null_string = sfpairs.shift
        unless initial_null_string == ''
          # do something about the error
        end
        
        sfpairs.each_slice(2).map {|code, val| MARC::Subfield.new(code, val) }
        
      end
      
      # Clean up fixed fields/leader, turning Ex Libris characters back into normal characters
      # @param [String] val The string to clean
      # @return [String] The cleaned string
      def cleanup_fixed(val)
        return val.gsub(TURN_TO_SPACE, ' ')
      end
        
      # Set the tag. As a side effect, set the type when we set the tag
      # type will end up as :leader, :control, :data, or :invalid_id
      def tag=(t)
        @tag = t
        if t == 'LDR'
          self.type = :leader
        elsif MARC::ControlField.control_tag?(t)
          self.type = :control
        elsif self.valid_id?
          self.type = :data
        else
          self.type = :invalid_id
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
    
 