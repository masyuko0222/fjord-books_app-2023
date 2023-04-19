Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  resources :users, only: %i[index show]
  resources :books
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "books#index"

  # letter_opener_web routing
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
end
