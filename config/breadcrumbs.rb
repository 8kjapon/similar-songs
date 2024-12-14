# 管理者ページ用のパンくずリスト設定
# ダッシュボードトップ
crumb :admin_root do
  link "Dashboard", admin_root_path
end

# 似てる曲組み合わせ一覧
crumb :admin_song_pairs do
  link "似てる曲組み合わせ", admin_song_pairs_path
  parent :admin_root
end

# 似てる曲組み合わせ編集
crumb :edit_admin_song_pair do |song_pair|
  link "#{song_pair.original_song.title} x #{song_pair.similar_song.title}", song_pair
  parent :admin_song_pairs
end

# 楽曲一覧
crumb :admin_songs do
  link "楽曲", admin_songs_path
  parent :admin_root
end

# 楽曲編集
crumb :edit_admin_song do |song|
  link "#{song.artist_list} - #{song.title}"
  parent :admin_songs
end

# アーティスト一覧
crumb :admin_artists do
  link "アーティスト", admin_artists_path
  parent :admin_root
end

# アーティスト編集
crumb :edit_admin_artist do |artist|
  link artist.name
  parent :admin_artists
end