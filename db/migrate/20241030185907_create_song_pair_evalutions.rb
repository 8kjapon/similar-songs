class CreateSongPairEvalutions < ActiveRecord::Migration[7.0]
  def change
    create_table :song_pair_evalutions do |t|
      t.references :user, foreign_key: true, null: false
      t.references :song_pair, foreign_key: true, null: false

      t.timestamps
    end
    add_index :song_pair_evalutions, [:user_id, :song_pair_id], unique: true
  end
end
