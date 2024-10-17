class CreateSongPairs < ActiveRecord::Migration[7.0]
  def change
    create_table :song_pairs do |t|
      t.references :original_song, foreign_key: { to_table: :songs }, null: false
      t.references :similar_song, foreign_key: { to_table: :songs }, null: false
      t.text :original_song_description, null: false
      t.text :similar_song_description, null: false
      t.belongs_to :similarity_category, foreign_key: true, null: false
      t.belongs_to :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
