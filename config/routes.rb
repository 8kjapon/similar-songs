Rails.application.routes.draw do
  # ルート
  root "home#top"

  # ユーザー関連
  resources :users, only: %i[new create]
  get 'mypage', to: 'users#show', as: :mypage
  get 'mypage/submit_songs', to: 'users#submit_songs', as: :submit_songs
  get 'mypage/evaluated_songs', to: 'users#evaluated_songs', as: :evaluated_songs
  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  # 楽曲関連
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

  # 楽曲組み合わせ関連
  resources :song_pairs, only: %i[index new create show edit update destroy]
  get 'recent', to: 'song_pairs#recent_page'
  get 'popular', to: 'song_pairs#popularity_page'
  resources :song_pair_evaluations, only: %i[create destroy]

  # アーティスト関連
  resources :artists, only: %i[] do
    collection do
      get 'autocomplete'
    end
  end
end
