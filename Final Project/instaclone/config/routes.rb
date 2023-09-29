Rails.application.routes.draw do
  devise_for :users

  root 'posts#index'

  get 'profile', to: 'users#profile', as: 'profile'
  get 'progress', to: 'progress#show', as: 'progress'

  # devise_for :users, controllers: { registrations: 'users/registrations' }

  resources :posts, only: %i[index new create edit update show destroy]
  resources :stories, only: %i[index new create show destroy]
  resources :likes, only: %i[create destroy]
  resources :comments, only: %i[create destroy]
  resources :relationships, only: %i[create destroy]

  resources :users, only: %i[show edit update] do
    member do
      get :followers, :followings
      post :follow
      delete :unfollow
    end
    collection do
      get :searchPage
    end
  end

  resources :posts do
    resources :likes, only: %i[create destroy]
    resources :comments, only: %i[create destroy]
  end

end
