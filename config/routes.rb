Rails.application.routes.draw do
  devise_for :users

  get 'about' => 'welcome#about'
  
  resources :users, only: [:show]

  resources :wikis


  root 'welcome#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
