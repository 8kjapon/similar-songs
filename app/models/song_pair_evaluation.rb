class SongPairEvaluation < ApplicationRecord
  belongs_to :user
  belongs_to :song_pair

  validates :user_id, uniqueness: { scope: :song_pair_id }
end
