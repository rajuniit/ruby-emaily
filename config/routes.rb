LmEmail::Application.routes.draw do

  devise_for :users

  resources :email_checkers
  resources :token_authentications, :only => [:create, :destroy]

  namespace :api do
    namespace :v1 do
      resources :email_checkers, :constraints => { :id => /.*/ }
    end
  end

  root :to => "home#index"
end
