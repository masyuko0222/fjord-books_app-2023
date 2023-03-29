Rails.application.routes.draw do
  get 'users/index'
  get 'users/show'
  get '/', to: redirect('/books')
  devise_for :users

  resources :users, :only => [:index, :show]
  resources :books
end
