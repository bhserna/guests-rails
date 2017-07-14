Rails.application.routes.draw do
  root "pages#index"
  resource :session, only: [:new, :create, :destroy]
  resources :registrations, only: [:new, :create]
  resources :lists, only: [:new, :create, :index, :show] do
    resources :invitations, only: [:create, :edit, :update] do
      resource :delivery_mark, only: [:create, :destroy]
      resource :guests_confirmation, only: [:new, :create]
    end
  end
end
