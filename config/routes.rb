Rails.application.routes.draw do
  # ルート
  root "home#top"

  # 静的ページ
  get 'rule', to: 'static_pages#rule'

  # ユーザー関連
  resources :users, only: %i[new create]
  get 'mypage', to: 'users#mypage'
  get 'mypage/submit_songs', to: 'users#submit_songs', as: :submit_songs
  get 'mypage/evaluated_songs', to: 'users#evaluated_songs', as: :evaluated_songs
  get 'mypage/edit', to: 'users#edit', as: :edit_mypage
  patch 'mypage', to: 'users#update'
  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  # 管理者関連
  namespace :admin do
    root 'dashboards#top'
    resources :song_pairs, only: %i[index edit update destroy]
    resources :songs, only: %i[index edit update destroy]
    resources :artists, only: %i[index edit update destroy]
    resources :users, only: %i[index edit update destroy] do
      member do
        get 'song_pairs', to: 'users#song_pairs'
      end
    end
    resources :contacts, only: %i[index edit update destroy]
  end

  # お問い合わせ関連
  resources :contacts, only: %i[new create]
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  # 楽曲関連
  resources :songs, only: %i[show] do
    member do
      get 'melody', to: 'songs#melody_song_pairs'
      get 'style', to: 'songs#style_song_pairs'
      get 'sampling', to: 'songs#sampling_song_pairs'
    end
    collection do
      get 'autocomplete', to: 'autocomplete#songs'
    end
  end

  # 楽曲組み合わせ関連
  resources :song_pairs, only: %i[index new create show edit update destroy] do
    collection do
      get 'autocomplete', to: 'autocomplete#search'
    end
  end
  get 'recent', to: 'song_pairs#recent_page'
  get 'popular', to: 'song_pairs#popularity_page'
  resources :song_pair_evaluations, only: %i[create destroy]

  # アーティスト関連
  resources :artists, only: %i[] do
    collection do
      get 'autocomplete', to: 'autocomplete#artists'
    end
  end
end
