WhereMyMates::Application.routes.draw do
  root :to => 'main#index'

  match 'auth/:provider/callback', to: 'sessions#create'
  match 'auth/failure', to: redirect('/')
  match 'signout', to: 'sessions#destroy', as: 'signout'
  match 'signin(/:invitation_key)', to: 'sessions#new', as: 'signin'
  match "/index2", to: "main#index2"

  resource :user, :only => [] do
    post :update_geo, :on => :member
  end

  resources :teams, only: [:show, :create]
end
