Rails.application.routes.draw do
  devise_for :views
  devise_for :users
  resources :contracts
  resources :crops
  resources :fields
  resources :farms
  resources :clients
  resources :farmers
  resources :solved_problems
  resources :users
  resources :problems
  resources :environments
  resources :baby_names
  resources :people

  root 'home#home'
  # root 'home#test'
end
