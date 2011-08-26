require 'test/unit'
require 'fact'

class TestFact < Test::Unit::TestCase
  def test_value_1
    assert_equal(1,1.fact,"1!")
  end
  def test_value_5
    assert_equal(120,5.fact,"5!")
  end
end
