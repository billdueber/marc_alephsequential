require 'zlib'

module MARC
  module AlephSequential

    # AlephSequential is a line-oriented format, with the first field of each line 
    # indicating the record number. Rather than try to screw around with keeping track of
    # the last line read, checking to see if we have one, blah blah blah, I'm going to use
    # a buffered line reader class so I can #push_back the last line read if it's key
    # is different than the current record. So when I'm pulling in a new record, I can just
    # call #next and not worry about it
    
    class BufferedLineReader
      
      include Enumerable
      
      
      def initialize(filename_or_io, buffer_size = 20)
        
        @buffer_size = buffer_size
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
      
      def fillbuffer
        begin
          @buffer_size.times do
            @buffer.push @iter.next
          end
        rescue StopIteration
          @finished = true
        end
      end
      
      def next
        if @buffer.size == 0 
          if @finished
            raise StopIteration, nil, nil
          else
            fillbuffer
          end
        end
        @buffer.shift
      end
      
      def peek
        @buffer[0]
      end
      
      def push_back(line)
        @buffer.unshift line.gsub(/\n$/, '')
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
        
        
        
      
      
      
      
      
      
      