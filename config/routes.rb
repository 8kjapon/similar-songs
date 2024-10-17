Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "home#top"
  resources :users, only: [:new, :create]
  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  resources :songs, only: [:show]
  resources :song_pairs, only: [:index, :new, :create, :show]
  get 'songs/autocomplete', to: 'songs#autocomplete'
  get 'artists/autocomplete', to: 'artists#autocomplete'
end
