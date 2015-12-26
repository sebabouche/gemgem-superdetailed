class ThingIntegrationTest < Trailblazer::Test::Integration
  it "allows anonymous" do
    visit "/things/new"
   
    # invalid.
    click_button "Create Thing"
    page.must_have_css ".error"

    # correct submit.
    fill_in 'Name', with: "Bad Religion"
    click_button "Create Thing"
    page.current_path.must_equal thing_path(Thing.last)
  end
end
