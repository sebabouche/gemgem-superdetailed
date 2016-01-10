class Thing::Cell::Form < Cell::Concept
  inherit_views Thing::Cell
  include ActionView::RecordIdentifier
  include SimpleForm::ActionViewExtensions::FormHelper
  
  def show
    render :form
  end

  private

  property :contract

  def css_class
    return "admin" if admin?
    return
  end

  def signed_in?
    model.policy.signed_in?
  end

  def admin?
    model.policy.admin?
  end

  def has_author_field?
    contract.options_for(:is_author)
  end
end

