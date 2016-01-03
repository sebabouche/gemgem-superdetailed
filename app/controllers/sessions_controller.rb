class SessionsController < ApplicationController

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

  def sign_in_form
    form Session::SignIn
  end

  def sign_in
    run Session::SignIn
  end
end

