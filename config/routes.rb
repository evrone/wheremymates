WhereMyMates::Application.routes.draw do
  root :to => 'main#index'
  match 'auth/:provider/callback', to: 'sessions#create'
  match 'auth/failure', to: redirect('/')
  match 'signout', to: 'sessions#destroy', as: 'signout'

  resource :user, :only => [] do
    post :update_geo, :on => :member
  end
end
