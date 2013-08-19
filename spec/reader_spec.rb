require 'helper'
require 'marc_alephsequential'

describe 'Reader' do
  before do
    @single = 'spec/data/single.seq'
    @batch =  'spec/data/batch.seq'
    @newline = 'spec/data/newline.seq'
    @noleader = 'spec/data/noleader.seq'
    
  end
  
  describe "empty reader" do
    it "doesn't blow up on an empty file" do
      iter = MARC::AlephSequential::Reader.new('/dev/null').each
      lambda{iter.next}.must_raise StopIteration
    end
  end
  
  it "reads a single record from a single-record file" do
    iter = MARC::AlephSequential::Reader.new(@single).each
    r = iter.next
    r['998'].value.must_equal '9665'
    r['100']['a'].must_equal 'Clark, Albert Curtis,'
  end
  
  it "reads a batch of records" do
    count = 0
    MARC::AlephSequential::Reader.new(@batch).each_with_index{|r, i| count = i + 1}
    count.must_equal 31
  end
  
  it "yells when there's no leader" do
    error = nil
    begin
      r = MARC::AlephSequential::Reader.new(@noleader).first
    rescue MARC::AlephSequential::Error => e
      error = e
    end
    error.wont_be_nil
    error.message.must_match /leader/
  end
  
  it "deals ok with embedded newline" do
    r = MARC::AlephSequential::Reader.new(@newline).first
    r['600']['a'].must_equal 'Cicero, Marcus Tullius'
    r['600']['x'].must_equal 'Manuscripts.'
  end
    
end
    