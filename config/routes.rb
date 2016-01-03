Rails.application.routes.draw do

  root to: "home#index"

  resources :things do
    member do
      post :create_comment
      get :next_comments
    end
    resources :comments
  end

  get  "session/sign_up_form"
  post "session/sign_up"
  get  "session/sign_in_form"
  post "session/sign_in"
  get  "session/sign_out"

end
