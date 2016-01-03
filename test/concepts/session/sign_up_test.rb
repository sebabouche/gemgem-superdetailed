require "test_helper"

class SignUpTest < MiniTest::Spec
  
  #valid signup
  it do
    res, op = Session::SignUp.run(user: {
      email: "selectport@trb.org",
      password: "123123",
      confirm_password: "123123"
    })

    op.model.persisted?.must_equal true
    op.model.email.must_equal "selectport@trb.org"
    assert Tyrant::Authenticatable.new(op.model).digest == "123123"
  end

  #TODO other tests
end
