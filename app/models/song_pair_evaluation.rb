class SongPairEvaluation < ApplicationRecord
  belongs_to :user
  belongs_to :song_pair

  validate :user_id, uniqueness: { scope: :song_pair_id }
end
