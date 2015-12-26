require 'test_helper'

class HomeIntegrationTest < Trailblazer::Test::Integration
  it do
    Thing.delete_all

    Thing::Create.(thing: { name: "Trailblazer" })
    Thing::Create.(thing: { name: "Descendents" })

    visit "/"

    page.must_have_css ".columns .header a", text: "Descendents"
    page.must_have_css ".columns.end .header a", text: "Trailblazer"
  end
end

