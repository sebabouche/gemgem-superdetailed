require 'test_helper'

class CommentOperationTest < MiniTest::Spec
  let (:thing) { Thing::Create.(thing: {name: "Ruby"}).model }

  describe "Create" do
    it "persists valid" do
      res, op = Comment::Create.run(
        comment: {
          body:   "Fantastic!",
          weight: "1",
          user:   { email: "jonny@trb.org" },
          thing: thing
        },
        id: thing.id
      )

      comment = op.model
      comment.persisted?.must_equal true 
      comment.body.must_equal "Fantastic!" 
      comment.weight.must_equal 1
      
      comment.user.persisted?.must_equal true 
      comment.user.email.must_equal "jonny@trb.org"

      op.thing.must_equal thing 
    end

    it "invalid email" do
      res, op = Comment::Create.run(
        comment: {
          user: { email: "12344@" }
        }
      )

      res.must_equal false
      op.errors.messages[:"user.email"].must_equal ["is invalid"]
    end
  end
end
