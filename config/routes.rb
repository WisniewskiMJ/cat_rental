Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :cats

  resources :cat_rental_requests, only: [:new, :create] do
    member do
      post :approve, to: 'cat_rental_requests#approve'
      post :deny, to: 'cat_rental_requests#deny'
    end
  end

  resources :users, only: [:new, :create, :show]

  resource :session, only: [:new, :create, :destroy]

end
