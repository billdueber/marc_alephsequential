require 'zlib'

module MARC
  module AlephSequential

    # AlephSequential is a line-oriented format, with the first field of each line 
    # indicating the record number. Rather than try to screw around with keeping track of
    # the last line read, checking to see if we have one, blah blah blah, I'm going to use
    # a buffered line reader class so I can #peek at the next line to know if its id 
    # is different than the current record. 
    
    class BufferedLineReader
      
      include Enumerable
      
      attr_accessor :buffer_size
      attr_reader :underlying_line_number
      
      def initialize(filename_or_io)
        
        @passed_in = filename_or_io
        
        @underlying_line_number = 0
        @buffer_size = 10
        @buffer = []
        
        if filename_or_io.is_a? String
          @handle = File.open(filename_or_io, 'r:utf-8')
          if filename_or_io =~ /\.gz$/
            @handle = Zlib::GzipReader.new(@handle)
          end
        elsif filename_or_io.respond_to?("read", 5)
          @handle = filename_or_io
        else
          raise ArgumentError.new("BufferedLineReader needs an IO object or filename, got #{filename_or_io} (#{filename_or_io.inspect})")
        end
        
        @iter = @handle.enum_for(:each_line)
        @finished = false
        # Fill up the buffer
        self.fillbuffer
      end
      
      def has_next?
        return !(@finished && @buffer.size == 0)
      end
      
      def fillbuffer(buffer_size = @buffer_size)
        begin
          buffer_size.times do
            raw = @iter.next
            @underlying_line_number += 1
            @buffer.push process_raw(raw, @underlying_line_number)
          end
        rescue StopIteration
          @finished = true
        end
      end
      
      # Empty version here; can override for processing lines on the fly
      def process_raw(raw, line_number)
        raw
      end
            
      def next
        raise StopIteration, "End of #{@passed_in}", nil if @buffer.size == 0
        rv = @buffer.shift
        fillbuffer if @buffer.size == 0
        rv
      end
        
      
      def peek
        fillbuffer unless @buffer.size > 0
        @buffer[0]
      end
            
      def each
        begin
          while true
            yield self.next
          end
        rescue StopIteration
        end
      end
      
      alias_method :each_line, :each
    end
  end
end
        
        
        
      
      
      
      
      
      
      