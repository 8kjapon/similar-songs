class CreateArtists < ActiveRecord::Migration[7.0]
  def change
    create_table :artists do |t|
      t.string :name, null: false

      t.timestamps
      
      t.index :name
    end
  end
end
