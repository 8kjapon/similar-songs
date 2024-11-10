class AddUniqueIndexSongArtistsAndSongPairs < ActiveRecord::Migration[7.0]
  def change
    add_index :song_artists, [:song_id, :artist_id], unique: true
    add_index :song_pairs, [:original_song_id, :similar_song_id], unique: true
  end
end
