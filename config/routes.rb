Rails.application.routes.draw do
  root "users#index"

  resources :users, only: %i[index new create]
end
