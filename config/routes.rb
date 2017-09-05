Rails.application.routes.draw do
  root "pages#index"
  resource :session, only: [:new, :create, :destroy]
  resources :registrations, only: [:new, :create]
  resource :page, only: [] do
    get :support
  end
  resources :lists, only: [:new, :create, :index, :show] do
    resource :name, only: [:edit, :update], controller: :list_names
    resources :invitations, only: [:create, :edit, :update, :destroy] do
      resource :delivery_mark, only: [:create, :destroy]
      resource :guests_confirmation, only: [:new, :create]
    end
  end
  resources :password_recoveries, only: [:new, :create]
  resources :passwords, only: [:edit, :update]
  resources :articles, only: [:show]

  #admin
  namespace :admin do
    resources :users, only: :index
    resources :lists, only: :index
  end
end
