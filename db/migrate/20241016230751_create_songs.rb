class CreateSongs < ActiveRecord::Migration[7.0]
  def change
    create_table :songs do |t|
      t.string :title, null: false
      t.string :release_date
      t.string :media_url, null: false

      t.timestamps

      t.index :title
    end
  end
end
