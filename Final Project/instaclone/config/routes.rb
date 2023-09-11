Rails.application.routes.draw do
  devise_for :users

  root 'posts#index'

  get 'profile', to: 'users#profile', as: 'profile'

  resources :posts, only: [:index, :new, :create, :edit, :update, :show, :destroy]
  resources :stories, only: [:index, :new, :create, :show, :destroy]
  resources :likes, only: [:create, :destroy]
  resources :comments, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]

  resources :users, only: [:show, :edit, :update] do
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
    resources :likes, only: [:create, :destroy]
    resources :comments, only: [:create, :destroy]
  end

end
