Rails.application.routes.draw do
  resources :baby_names
  resources :people

  get 'sandbox/interact' => 'sandbox#interact'
  get 'sandbox/inspect' => 'sandbox#inspect'
  get 'sandbox/kata' => 'sandbox#kata'
  root 'sandbox#inspect'
end
