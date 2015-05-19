require 'marc'
require 'yell'
require 'marc_alephsequential/asline_reader'
require 'marc_alephsequential/asline_group'
require 'marc_alephsequential/log'

module MARC
  module AlephSequential

    # We need an empty record to signal an error condition that might
    # occur within #each (e.g, the record has no leader). Raising the
    # error will abort any #each loop without giving the user a chance
    # to catch is (because by the time the block is run, the error has
    # already been thrown). See a simplified example of this problem at
    # https://gist.github.com/billdueber/6d501f730c79f6a74498


    class ErrorRecord < MARC::Record
      attr_accessor :error
      def initialize(error)
        super()
        self.error = error
      end
    end

    class Reader

      include Enumerable
      include Log

      attr_reader :lines
      attr_accessor :current_id

      def initialize(filename_or_io, opts={})
        @areader = ASLineReader.new(filename_or_io)
      end

      def each

        unless block_given?
          return enum_for(:each)
        end

        agroup = ASLineGroup.new

        while @areader.has_next?
          nextid = @areader.peek.id
          if nextid != @current_id && @areader.peek.valid_id?
            begin
              yield agroup.to_record unless agroup.empty?
            rescue RuntimeError => e
              yield ErrorRecord.new(e)
            end
            agroup      = ASLineGroup.new
            @current_id = nextid
          else
            agroup.add @areader.next
          end
        end
        # yield whatever is left, unless there's nothing left
        begin
          yield agroup.to_record unless agroup.empty?
        rescue RuntimeError => e
          yield ErrorRecord.new(e)
        end

      end
    end
  end
end








