Rails.application.routes.draw do
  root "pages#index"
  resources :registrations, only: [:new, :create]
end
