Rails.application.routes.draw do

  devise_for :users

  get 'about' => 'welcome#about'

  get 'downgrade' => 'charges#downgrade'

  resources :users, only: [:show]

  resources :wikis

  resources :charges, only: [:new, :create, :destroy]

  root 'welcome#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
