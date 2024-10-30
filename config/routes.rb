Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "home#top"
  resources :users, only: %i[new create]
  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  resources :songs, only: %i[show] do
    member do
      get 'melody', to: 'songs#melody_song_pairs'
      get 'style', to: 'songs#style_song_pairs'
      get 'sampling', to: 'songs#sampling_song_pairs'
    end
    collection do
      get 'autocomplete'
    end
  end
  resources :song_pairs, only: %i[index new create show]
  get 'recent', to: 'song_pairs#recent_page'
  get 'popular', to: 'song_pairs#popularity_page'
  resources :song_pair_evalutions, only: %i[create destroy]
  resources :artists, only: %i[] do
    collection do
      get 'autocomplete'
    end
  end
end
