class AddInitialSimilarityCategories < ActiveRecord::Migration[7.0]
  def up
    SimilarityCategory.create(name: 'melody')
    SimilarityCategory.create(name: 'style')
    SimilarityCategory.create(name: 'sampling')
  end

  def down
    SimilarityCategory.delete_all
  end
end
