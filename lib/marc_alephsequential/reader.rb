require 'marc'
require 'yell'
require 'marc_alephsequential/asline_reader'
require 'marc_alephsequential/asline_group'
require 'marc_alephsequential/log'

module MARC
  module AlephSequential

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
            yield agroup.to_record unless agroup.empty?
            agroup      = ASLineGroup.new
            @current_id = nextid
          else
            agroup.add @areader.next
          end
        end
        # yield whatever is left, unless there's nothing left
        yield agroup.to_record unless agroup.empty?
      end
    end
  end
end








