require_relative 'helper'
require 'marc_alephsequential'


describe "version" do
  it "must exist" do
    version = MarcAlephsequential.const_get('VERSION')
    version.wont_be_empty
  end
end
