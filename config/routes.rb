require 'resque/server'

Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'posts#index'
  resources :posts do
    resources :comments, only: [:create]
  end
  resources :users, only: [:show]

  mount Resque::Server.new, :at => "/resque"

end