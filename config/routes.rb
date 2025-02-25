Rails.application.routes.draw do
  root "pages#index"
  resource :session, only: [:new, :create, :destroy]
  resources :registrations, only: [:new, :create]
  resources :wedding_planner_registrations, only: [:new, :create]
  resource :page, only: [] do
    get :support
  end
  resources :lists, only: [:new, :create, :edit, :update, :index, :show] do
    get :search, on: :member
    resources :accesses, only: [:index, :new, :create, :edit, :update, :destroy], controller: :list_accesses do
      resources :notifications, only: :create, controller: :list_access_notifications
    end
    resources :invitations, only: [:new, :create, :edit, :update, :destroy] do
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
