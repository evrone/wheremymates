WhereMyMates::Application.routes.draw do
  root :to => 'main#index'

  match 'auth/:provider/callback', to: 'sessions#create'
  match 'auth/failure', to: redirect('/')
  match 'signout', to: 'sessions#destroy', as: 'signout'
  match 'signin', to: 'sessions#new', as: 'signin'

  resource :user, :only => [] do
    post :update_geo, :on => :member
  end

  match 'teams/:invitation_key/join', to: 'teams#join', as: 'join_to_team'
  resources :teams, only: [:new, :show, :create] do
    member do
      put :leave
    end
  end
end
