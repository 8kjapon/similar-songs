class Song < ApplicationRecord
  has_many :song_artists
  has_many :artists, through: :song_artists
  has_many :song_pair

  validates :title, presence: true, length: { maximum: 255 }
  validates :media_url, presence: true
end
