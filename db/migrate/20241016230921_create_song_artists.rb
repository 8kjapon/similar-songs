class CreateSongArtists < ActiveRecord::Migration[7.0]
  def change
    create_table :song_artists do |t|
      t.references :song, foreign_key: true, null: false
      t.references :artist, foreign_key: true, null:false

      t.timestamps
    end
  end
end
