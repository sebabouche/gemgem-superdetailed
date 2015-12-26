require 'test_helper'

class HomeIntegrationTest < Trailblazer::Test::Integration
  it do
    Thing::Create.(thing: {name: "Rails"})

    visit "/"

    page.must_have_css ".columns .header a", text: "Rails"
  end
end

