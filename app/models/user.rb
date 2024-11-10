class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :song_pairs
  has_many :song_pair_evaluations, dependent: :destroy
  has_many :evaluated_song_pairs, through: :song_pair_evaluations, source: :song_pair

  validates :name, presence: true, length: { minimum: 3, maximum: 255 }
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  # SongPairが評価された場合の処理
  def song_pair_evaluation(song_pair)
    evaluated_song_pairs << song_pair
  end

  # SongPairの評価が取り消された場合の処理
  def song_pair_unevaluation(song_pair)
    evaluated_song_pairs.destroy(song_pair)
  end

  # SongPairが評価されているかを判断する処理
  def song_pair_evaluated?(song_pair)
    evaluated_song_pairs.include?(song_pair)
  end
end
