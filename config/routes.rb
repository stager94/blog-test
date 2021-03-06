Rails.application.routes.draw do

  get "sign_up" => "users#new", as: "sign_up"
  get "log_in" => "sessions#new", as: "log_in"
  delete "log_out" => "sessions#destroy", as: "log_out"

  root 'posts#index'

  resources :users do
    resources :posts, only: [:index]
  end
  resources :sessions
  resources :posts do
    resources :comments
    get :by_tag, on: :collection
  end
end
