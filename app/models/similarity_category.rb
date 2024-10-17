class SimilarityCategory < ApplicationRecord
  has_many :song_pairs

  validates :name, presence: true
end
