require "test_helper"

class AuthorshipTest < ActiveSupport::TestCase
  def authorship
    @authorship ||= Authorship.new
  end

  def test_valid
    assert authorship.valid?
  end
end
