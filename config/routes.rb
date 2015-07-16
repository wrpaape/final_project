Rails.application.routes.draw do
  resources :fields
  resources :farms
  resources :contracts
  resources :crops
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
