class Thing::Policy
  attr_reader :model, :user

  def initialize(user, model)
    @user, @model = user, model
  end

  def create?
    true
  end
end
