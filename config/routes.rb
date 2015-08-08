Rails.application.routes.draw do
  resources :memberships
  resources :studies
  resources :assignments
  resources :projects
  resources :languages
  resources :programmers
  resources :communities
  resources :act_rec_methods
  get "solved_problems/new/:problem_id", to: "solved_problems#new"
  devise_for :users, :controllers => { sessions: "sessions", registrations: "registrations" }
  devise_for :views
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

  root "home#home"
end
