require 'helper'
require 'marc_alephsequential'

describe "ASLineGroup" do
  before do
    @single_lines = File.open('spec/data/single.seq').read.split("\n")
    @full = MARC::AlephSequential::ASLineGroup.new
    @single_lines.each_with_index {|l,i| @full.add_string(l,i ) }

  end


  describe "Create Group" do
    before do
      @ag = MARC::AlephSequential::ASLineGroup.new
    end

    it "should start empty" do
      @ag.must_be_empty
    end

    it "should read in a valid record" do
      @ag = MARC::AlephSequential::ASLineGroup.new
      File.open('spec/data/single.seq').each_with_index {|l,i| @ag.add_string(l,i ) }
      @ag.size.must_equal 33
      @ag.leader.must_equal '     nam a22003011  4500'
      @ag.aslines[0].tag.must_equal '001'
      @ag.aslines[1].tag.must_equal '003'
      @ag.aslines[1].type.must_equal :control
    end

    it "should deal with embedded newlines" do
      tinyrec = [
        "000000794 LDR   L ^^^^^nam^a22003011^^4500",
        "000000794 001   L 000000794",
        "000000794 005   L 19880715000000.0",
        "000000794 1001  L $$aClark, Albert ",
        "Curtis,$$d1859-1937.",
        "000000794 24514 L $$aThe descent of manuscripts"
      ]

      tinyrec.each_with_index {|l,i| @ag.add_string(l,i) }
      field = @ag.aslines[2].to_field
      field.tag.must_equal '100'
      field['a'].must_equal 'Clark, Albert Curtis,'
    end

    it "should produce a good record" do
      rec = @full.to_record
      rec['001'].value.must_equal '000000794'
      rec['998'].value.must_equal '9665'
    end



  end



end
