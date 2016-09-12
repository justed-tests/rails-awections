Rails.application.routes.draw do
  get 'auctions/create'

  root 'products#index'

  devise_for :users
  resources :products do
    resources :auctions, only: [:create]
  end
end
