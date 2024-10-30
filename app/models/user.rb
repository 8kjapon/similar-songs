class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :song_pairs
  has_many :song_pair_evalutions, dependencies: :destroy
  has_many :evaluated_song_pairs, through: :song_pair_evalutions, source: :song_pair

  validates :name, presence: true, length: {minimum:3, maximum:255}
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
end
