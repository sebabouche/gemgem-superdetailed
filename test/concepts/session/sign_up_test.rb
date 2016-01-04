require "test_helper"

class SessionSignUpTest < MiniTest::Spec
  # successful.
  it do
    res, op = Session::SignUp.run(user: {
      email: "selectport@trb.org",
      password: "123123",
      confirm_password: "123123",
    })

    op.model.persisted?.must_equal true
    op.model.email.must_equal "selectport@trb.org"

    assert Tyrant::Authenticatable.new(op.model).digest == "123123"
  end

  # not filled out.
  it do
    res, op = Session::SignUp.run(user: {
      email: "",
      password: "",
      confirm_password: "",
    })

    res.must_equal false
    op.model.persisted?.must_equal false
    op.errors.to_s.must_equal "{:email=>[\"can't be blank\"], :password=>[\"can't be blank\"], :confirm_password=>[\"can't be blank\"]}"
  end

  # password mismatch.
  it do
    res, op = Session::SignUp.run(user: {
      email: "selectport@trb.org",
      password: "123123",
      confirm_password: "wrong because drunk",
    })

    res.must_equal false
    op.model.persisted?.must_equal false
    op.errors.to_s.must_equal "{:password=>[\"Passwords don't match\"]}"
  end
end
