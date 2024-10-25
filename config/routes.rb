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

  resources :songs, only: [:show] do
    member do
      get 'melody', to: 'songs#melody_song_pairs'
      get 'style', to: 'songs#style_song_pairs'
      get 'sampling', to: 'songs#sampling_song_pairs'
    end
    collection do
      get 'autocomplete'
    end
  end
  resources :song_pairs, only: [:index, :new, :create, :show]
  get 'recent', to: 'song_pairs#recent_page'
  resources :artists, only: [] do
    collection do
      get 'autocomplete'
    end
  end
end
