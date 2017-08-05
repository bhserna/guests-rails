Rails.application.routes.draw do
  root "pages#index"
  resource :session, only: [:new, :create, :destroy]
  resources :registrations, only: [:new, :create]
  resource :page, only: [] do
    get :support
  end
  resources :lists, only: [:new, :create, :index, :show] do
    resources :invitations, only: [:create, :edit, :update, :destroy] do
      resource :delivery_mark, only: [:create, :destroy]
      resource :guests_confirmation, only: [:new, :create]
    end
  end

  #admin
  resources :users, only: :index
end
