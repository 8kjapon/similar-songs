class CreateSimilarityCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :similarity_categories do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
