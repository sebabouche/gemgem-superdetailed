require "test_helper"

class ThingTest < ActiveSupport::TestCase
  def thing
    @thing ||= Thing.new
  end

  def test_valid
    assert thing.valid?
  end
end
