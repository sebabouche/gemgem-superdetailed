require 'test_helper'

class ThingCellTest < Cell::TestCase 
  controller ThingsController
  
  before do
    Thing::Create.(thing: {name: "Rails"})
    Thing::Create.(thing: {name: "Trailblazer"})
  end

  subject {concept("thing/cell/grid").to_s}

  it do
    skip("Not working")
    subject.must_have_selector ".columns .header a", text: "Rails" 
    subject.must_not_have_selector ".columns.end .header a", text: "Rails" 
    subject.must_have_selector ".columns.end .header a", text: "Trailblazer"
  end
end

