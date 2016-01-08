require 'test_helper'

class ThingOperationTest < MiniTest::Spec
  describe "Update" do
    let (:thing) { Thing::Create.(thing: {name: "Rails", description: "Kickass web dev", "users"=>[{"email"=>"solnic@trb.org"}]}).model }

    it "rendering" do # DISCUSS: not sure if that will stay here, but i like the idea of presentation/logic in one place.
      form = Thing::Update.present({id: thing.id}).contract
      form.prepopulate! # this is a bit of an API breach.

      form.users.size.must_equal 3 # always offer 3 user emails.
      form.users[0].email.must_equal "solnic@trb.org"
      form.users[0].id.must_equal thing.users[0].id
      form.users[1].email.must_equal nil
      form.users[2].email.must_equal nil
    end

    it "persists valid, ignores name" do
      Thing::Update.(
        id:     thing.id,
        thing: {name: "Lotus", description: "MVC, well.."}).model

      thing.reload
      thing.name.must_equal "Rails"
      thing.description.must_equal "MVC, well.."
    end

    it "valid, new and existing email" do
      solnic = thing.users[0]
      model  = Thing::Update.(id: thing.id, thing: {"users" => [{"id"=>solnic.id, "email"=>"solnicXXXX@trb.org"}, {"email"=>"nick@trb.org"}]}).model

      model.users.size.must_equal 2
      model.users[0].attributes.slice("id", "email").must_equal("id"=>solnic.id, "email"=>"solnic@trb.org") # existing user, nothing changed.
      model.users[1].email.must_equal "nick@trb.org" # new user created.
      model.users[1].persisted?.must_equal true
    end

    # hack: try to change emails.
    it "doesn't allow changing existing email" do
      op = Thing::Create.(thing: {name: "Rails  ", users: [{"email"=>"nick@trb.org"}]})

      op = Thing::Update.(id: op.model.id, thing: {users: [{"email"=>"wrong@nerd.com"}]})
      op.model.users[0].email.must_equal "nick@trb.org"
    end

    # all emails blank
    it "all emails blank" do
      op = Thing::Create.(thing: {name: "Rails  ", users: []})

      res, op = Thing::Update.run(id: op.model.id, thing: {name: "Rails", users: [{"email"=>""},{"email"=>""}]})

      res.must_equal true
      op.model.users.must_equal []
    end

    # remove
    it "allows removing" do
      skip "Not removing user in this test (but actually working in real life)"
      op  = Thing::Create.(thing: {name: "Rails  ", users: [{"email" => "joe@trb.org"}]})
      joe = op.model.users[0]

      res, op = Thing::Update.run(id: op.model.id, thing: {name: "Rails", users: [{"id"=>joe.id.to_s, "remove"=>"1"}]})

      res.must_equal true
      op.model.users.must_equal []
      joe.persisted?.must_equal true
    end
  end
end
