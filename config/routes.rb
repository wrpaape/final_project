Rails.application.routes.draw do
  resources :users
  resources :baby_names
  resources :people

  get 'sandbox/interact' => 'sandbox#interact'
  get 'sandbox/inspect' => 'sandbox#inspect'
  get 'sandbox/kata' => 'sandbox#kata'

  get 'user/:id/query_info' => 'user#query_info'

  root 'sandbox#inspect'
end
