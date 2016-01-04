class ApplicationController < ActionController::Base
  include Trailblazer::Operation::Controller
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def tyrant
    Tyrant::Session::new(request.env["warden"])
  end
  helper_method :tyrant
end
