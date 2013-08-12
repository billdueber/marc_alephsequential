require 'marc'

module MARC
  module AlephSequential
    class Reader
      
      attr_accessor :log
      attr_reader :lines
      
      SUBFIELD_SPLIT_PATTERN = /\$\$([a-zA-Z0-9])/
      
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
      
      
      
      # Get a line and parse it out into its componant parts
      # @param [String] line the line to parse
      # @return [Array] An array of the form [id, tag, ind1, ind2, value]
      
      def parseline(line)
        id = line[0,9]
        tag = line[10,3]
        ind1 = line[13,1]
        ind2 = line[14,1]
        value = line[18,-1]
        return [id,tag,ind1,ind2,value]
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
        

      # Build a field of the correct type from a line, based on the tag
      # @param [String] line The line to parse
      # @return [MARC::Field] an appropriate MARC::ControlField or MARC::DataField
      
      
        
      
      
      
      
      
      
      