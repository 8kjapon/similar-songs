class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :song_pairs

  validates :name, presence: true, length: {minimum:3, maximum:255}
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
end
