class CreateSimilarityCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :similarity_categories do |t|
      t.string :name, null: false

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        similarity_categories.create!(name: 'melody')
        similarity_categories.create!(name: 'style')
        similarity_categories.create!(name: 'sampling')
      end
    end
  end
end
