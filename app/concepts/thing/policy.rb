class Thing::Policy
  attr_reader :model, :user

  def initialize(user, model)
    @user, @model = user, model
  end

  def create?
    true
  end

  def signed_in?
    user.present?
  end

  def admin?
    signed_in? and user.email == "admin@trb.org"
  end

  def update?
    edit?
  end

  def edit?
    signed_in? and (admin? or model.users.include?(user))
  end

  def show?
    return true
  end

  def delete?
    return false
  end
end
