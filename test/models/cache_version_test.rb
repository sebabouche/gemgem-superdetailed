require "test_helper"

class CacheVersionTest < ActiveSupport::TestCase
  def cache_version
    @cache_version ||= CacheVersion.new
  end

  def test_valid
    assert cache_version.valid?
  end
end
