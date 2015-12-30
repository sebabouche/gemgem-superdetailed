require 'test_helper'

class ThingOperationTest < MiniTest::Spec
  describe "Create" do
    it "persists valid" do
      thing = Thing::Create.(thing: {name: "Rails", description: "Kickass web dev"}).model

      thing.persisted?.must_equal true
      thing.name.must_equal "Rails"
      thing.description.must_equal "Kickass web dev"
    end

    it "invalid" do
      res, op = Thing::Create.run(thing: {name: ""})

      res.must_equal false
      op.model.persisted?.must_equal false 
      op.contract.errors.to_s.must_equal "{:name=>[\"can't be blank\"]}"
    end
    
    it "invalid description" do
      res, op = Thing::Create.run(thing: {name: "Rails", description: "hi"})

      res.must_equal false 
      op.contract.errors.to_s.must_equal "{:description=>[\"is too short (minimum is 4 characters)\"]}" 

    end

    # users
    it "invalid email" do
      res, op = Thing::Create.run(thing: {name: "Rails", users: [{"email"=>"invalid format"}, {"email"=>"bla"}]})

      res.must_equal false
      op.errors.to_s.must_equal "{:\"users.email\"=>[\"is invalid\"]}"

      # still 3 users
      form = op.contract
      form.prepopulate! # FIXME: hate this. move prepopulate! to Op#run.

      form.users.size.must_equal 3 # always offer 3 user emails.
      form.users[0].email.must_equal "invalid format"
      form.users[1].email.must_equal "bla"
      form.users[2].email.must_equal nil # this comes from prepopulate!
    end
    
    # all emails blank
    it "all emails blank" do
      res, op = Thing::Create.run(thing: {name: "Rails", users: [{"email"=>""}]})

      res.must_equal true
      op.model.users.must_equal []
    end

    it "valid, new and existing email" do
      solnic = User.create(email: "solnic@trb.org") # TODO: replace with operation, once we got one.
      User.count.must_equal 1

      model = Thing::Create.(thing: {name: "Rails", users: [{"email"=>"solnic@trb.org"}, {"email"=>"nick@trb.org"}]}).model

      model.users.size.must_equal 2
      model.users[0].attributes.slice("id", "email").must_equal("id"=>solnic.id, "email"=>"solnic@trb.org") # existing user attached to thing.
      model.users[1].email.must_equal "nick@trb.org" # new user created.

      # authorship is not confirmed, yet.
      model.authorships.pluck(:confirmed).must_equal [0, 0]
    end

    # too many users
    it "users > 3" do
      emails = 4.times.collect { |i| {"email"=>"#{i}@trb.org"} }
      res, op = Thing::Create.run(thing: {name: "Rails", users: emails})

      res.must_equal false
      op.errors.to_s.must_equal "{:users=>[\"is too long (maximum is 3 characters)\"]}"
    end

    # author has more than 5 unconfirmed authorships.
    it do
      5.times { |i| Thing::Create.(thing: {name: "Rails #{i}", users: [{"email"=>"nick@trb.org"}]}) }
      res, op = Thing::Create.run(thing: {name: "Rails", users: [{"email"=>"nick@trb.org"}]})

      res.must_equal false
      op.errors.to_s.must_equal "{:\"users.user\"=>[\"This user has too many unconfirmed authorships.\"]}"
    end
  end

  describe "Update" do
    let (:thing) { Thing::Create.(thing: { name: "Rails", description: "Kickass web dev" }).model }

    it "persists valid, ignores name" do
      Thing::Update.(
        id: thing.id,
        thing: {
          name: "Lotus",
          description: "Simply better…"
        }
      )

      thing.reload
      thing.name.must_equal "Rails"
      thing.description.must_equal "Simply better…"
    end
  end
end
