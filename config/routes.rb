Rails.application.routes.draw do
  get 'auctions/create'

  root 'products#index'

  devise_for :users

  resources :products do
    resources :auctions, only: [:create] do
      resources :bids, only: [:create]
    end

    member do
      put :transfer
    end
  end
end
