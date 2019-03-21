Rails.application.routes.draw do
  root to: 'toppages#index'
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  get 'signup', to: 'users#new'
  
  resources :users, only: [:index, :show, :new, :create] do
    member do
      get :followings
      get :followers
      get :likes
    end
  end
  
  #投稿機能
  resources :microposts, only:[:create, :destroy]

  #フォロー機能
  resources :relationships, only: [:create, :destroy]
  
  #お気に入り機能
  resources :favorites, only:[:create, :destroy]
end