require 'test_helper'

class ThingCreateIntegrationTest < Trailblazer::Test::Integration

  def assert_new_form
    # every field editable
    page.must_have_css "form #thing_name"
    page.wont_have_css "form #thing_name.readonly"

    # 3 author email fields
    page.must_have_css("input.email", count: 3) # TODO: how can i say "no value"?
  end

  describe "#new" do
    it "allows anonymous" do
      # new
      visit "/things/new"

      assert_new_form
      page.wont_have_css("#thing_is_author")
      page.wont_have_css("form.admin")
    end

    it "allows signed in" do
      sign_in!
      visit "/things/new"
      assert_new_form
      page.must_have_css("#thing_is_author")
      page.wont_have_css("form.admin")
    end
  end

  describe "lifecycle" do
    it "anonymous" do
      visit "/things/new"
      
      # invalid
      click_button "Create Thing"
      page.must_have_css ".error"
      
      # skip see below
      #page.must_have_css "input.email", count: 3

      # correct submit.
      fill_in 'Name', with: "Bad Religion"
      click_button "Create Thing"
      page.current_path.must_equal thing_path(Thing.last)
      page.body.must_match /Bad Religion/
      # page.wont_have_css "a", text: "Edit" not yey implemented!
    end

    it "signed in" do
      sign_in!
      visit "/things/new"

      #invalid
      click_button "Create Thing"
      page.must_have_css ".error"

      # correct submit
      fill_in 'Name', with: "Bad Religion"
      check "I'm the author!"
      click_button "Create Thing"
      page.current_path.must_equal thing_path(Thing.last)
      page.must_have_content "By fred@trb.org"
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
  end
end
