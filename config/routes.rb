Rails.application.routes.draw do
  root "pages#index"
  resource :session, only: [:new, :create, :destroy]
  resources :registrations, only: [:new, :create]
  resources :lists, only: [:new, :create, :index]
end
