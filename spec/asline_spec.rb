require 'helper'
require 'marc_alephsequential'

describe 'ASLine' do
  before do
    @leader = '000000794 LDR   L ^^^^^nam^a22003011^^4500'
    @c1     = '000000794 008   L 880715r19701918enk^^^^^^b^^^|00100^eng^^'
    @c2     = '000000794 001   L 000000794'
    @d1     = '000000794 1001  L $$aClark, Albert Curtis,$$d1859-1937.'
    @d2     = '000000794 60000 L $$aPlato.$$tCritias$$xManuscripts.'
  end
  
  
  it "correctly parses a leader" do
    aline = MARC::AlephSequential::ASLine.new(@leader, 1)
    aline.type.must_equal :leader
    aline.value.must_equal '     nam a22003011  4500'
  end
  
  it "parses control fields" do
    aline = MARC::AlephSequential::ASLine.new(@c1, 1)
    aline.tag.must_equal '008'
    aline.value.must_equal '880715r19701918enk      b   |00100 eng  '
  end
  
  it "parses datafield basics" do 
    aline = MARC::AlephSequential::ASLine.new(@d1, 1)
    aline.tag.must_equal '100'
    aline.ind1.must_equal '1'
    aline.ind2.must_equal ' '
  end
  
  it "parses subfields" do
    aline = MARC::AlephSequential::ASLine.new(@d1, 1)
    subfields = aline.parse_string_into_subfields(aline.value)
    subfields[0].code.must_equal 'a'
    subfields[1].code.must_equal 'd'
    subfields[0].value.must_equal 'Clark, Albert Curtis,'
    subfields[1].value.must_equal '1859-1937.'
    
  end
  
    
  
end
  