class Artist < ApplicationRecord
  has_many :song_artists
  has_many :song, through: :song_artists

  validates :name, presence: true, length: { maximum: 255 }
end
