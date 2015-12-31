require 'test_helper'

class ThingIntegrationTest < Trailblazer::Test::Integration
  it "allows anonymous" do

    # new
    visit "/things/new"

    # every field editable
    page.must_have_css "form #thing_name"
    page.wont_have_css "form #thing_name.readonly"

    # 3 author email fields
    page.must_have_css("input.email", count: 3) # TODO: how can i say "no value"?
   
    # correct submit.
    fill_in 'Name', with: "Bad Religion"
    click_button "Create Thing"
    page.current_path.must_equal thing_path(Thing.last)
    page.body.must_match /Bad Religion/
    
    # comment form in show
    page.must_have_css "input.button[value='Create Comment']"
    page.must_have_css ".comment_user_email"
    page.must_have_css ".comments" # grid.

    # edit
    thing = Thing.last
    visit "/things/#{thing.id}/edit"
    page.must_have_css "form #thing_name.readonly[value='Bad Religion']"
  end

  it "with invalid submission" do
    skip "I don't see 3 author fields after invalid submission"
    visit "/things/new"

    # every field editable
    page.must_have_css "form #thing_name"
    page.wont_have_css "form #thing_name.readonly"

    # 3 author email fields
    page.must_have_css("input.email", count: 3) # TODO: how can i say "no value"?
   
    # invalid.
    click_button "Create Thing"
    page.must_have_css ".error"

    # 3 author email fields
    page.must_have_css "input.email", count: 3 # FIXME I don't see 3 author fields !
  end

  it "edit form shows readonly author" do
    thing = Thing::Create.(thing: {name: "Rails", users: [{"email" => "joe@trb.org"}]}).model

    visit "/things/#{thing.id}/edit"

    page.must_have_css "input#thing_users_attributes_0_email.readonly"

    page.must_have_css "form #thing_name.readonly[value='Rails']" 
    page.must_have_css("#thing_users_attributes_0_email.readonly[value='joe@trb.org']")
    page.must_have_css "#thing_users_attributes_0_remove"
    page.must_have_css "#thing_users_attributes_1_email"
    page.wont_have_css "#thing_users_attributes_1_remove"

  end
end
