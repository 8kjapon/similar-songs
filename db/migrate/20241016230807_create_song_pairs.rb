class CreateSongPairs < ActiveRecord::Migration[7.0]
  def change
    create_table :song_pairs do |t|
      t.references :original_song, foreign_key: { to_table: :song }, null: false
      t.references :similar_song, foreign_key: { to_table: :song }, null: false
      t.text :original_song_description, null: false
      t.text :similar_song_description, null: false
      t.belong_to :similarity_category, null: false
      t.belong_to :user, null: false

      t.timestamps
    end
  end
end
