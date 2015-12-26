require 'test_helper'

class ThingCellTest < Cell::TestCase 
  controller ThingsController
  
  let(:rails) { Thing::Create.(thing: {name: "Rails"}).model }
  let(:trb)   { Thing::Create.(thing: {name: "Trailblazer"}).model }
  

  it do
    skip("NoMethodError: undefined method `must_have_selector' for #<ActiveSupport::SafeBuffer:0x007fb9b26788d8>")
    html = concept("thing/cell", collection: [trb, rails], last: rails)
    html.must_have_selector ".columns .header a", text: "Rails" 
    html.must_not_have_selector ".columns.end .header a", text: "Rails" 
    html.must_have_selector ".columns.end .header a", text: "Trailblazer"
  end
end

