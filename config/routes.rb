WhereMyMates::Application.routes.draw do
  root :to => 'main#index'

  get 'auth/:id' => 'sessions#new', :as => 'auth'
  match 'auth/:provider/callback', to: 'sessions#create'
  match 'auth/failure', to: redirect('/')
  match 'signout', to: 'sessions#destroy', as: 'signout'

  resources :users, :only => :show
  resource :user, :only => [:edit, :update] do
    post :update_geo, :on => :member
  end

  match 'teams/:invitation_key/join', to: 'entries#create', :as => 'entry'
  resources :teams, only: [:index, :new, :show, :create] do
    get :embed, :on => :member
    resource :entry, :only => :destroy
  end
end
