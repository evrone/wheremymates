WhereMyMates::Application.routes.draw do
  root :to => 'main#index'

  match 'auth/:provider/callback', to: 'sessions#create'
  match 'auth/failure', to: redirect('/')
  match 'signout', to: 'sessions#destroy', as: 'signout'
  match 'signin', to: 'sessions#new', as: 'signin'

  resource :user, :only => [] do
    post :update_geo, :on => :member
  end

  match 'teams/:invitation_key/join', to: 'entries#create', :as => 'entry'
  resources :teams, only: [:index, :new, :show, :create] do
    resource :entry, :only => :destroy
  end
end
