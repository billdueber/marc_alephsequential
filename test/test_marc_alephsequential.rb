require 'helper'
require 'marc_alephsequential'

class TestMarcAlephsequential < Test::Unit::TestCase

  def test_version
    version = MarcAlephsequential.const_get('VERSION')

    assert !version.empty?, 'should have a VERSION constant'
  end

end
