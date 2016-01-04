class SessionsController < ApplicationController

  before_filter only: [:sign_in_form, :sign_in] do
    redirect_to root_path if tyrant.signed_in? 
  end

  def sign_in_form
    form Session::SignIn
  end

  def sign_in
    run Session::SignIn do |op|
      tyrant.sign_in!(op.model)
      return redirect_to root_path
    end

    render action: :sign_in_form
  end

  def sign_up_form
    form Session::SignUp
  end

  def sign_up
    run Session::SignUp do |op|
      flash[:notice] = "Please log in now!"
      return redirect_to sessions_sign_in_form_path
    end

    render action: :sign_up_form
  end

  def sign_out
    run Session::SignOut do
      tyrant.sign_out!
      redirect_to root_path
    end
  end
end
