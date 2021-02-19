Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'cats#index'

  resources :cats

  resources :cat_rental_requests, only: [:new, :create] do
    member do
      post :approve, to: 'cat_rental_requests#approve'
      post :deny, to: 'cat_rental_requests#deny'
    end
  end

  resources :users

  resource :session, only: [:new, :create, :destroy]

end
