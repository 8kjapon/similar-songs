class SimilarityCategory < ApplicationRecord
  has_many :song_pairs, dependent: :nullify

  validates :name, presence: true
end
