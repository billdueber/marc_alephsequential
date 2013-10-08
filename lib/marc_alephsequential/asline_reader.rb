require_relative 'asline'
require_relative 'buffered_linereader'

module MARC
  module AlephSequential

    class ASLineReader < BufferedLineReader
      def process_raw(raw, line_number)
        super
        ASLine.new(raw, line_number)
      end

    end
  end
end

