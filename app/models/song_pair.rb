class SongPair < ApplicationRecord
  belongs_to :user
  belongs_to :original_song, class_name: 'Song'
  belongs_to :similar_song, class_name: 'Song'
  belongs_to :similarity_category
  
  validates :original_song_id, uniqueness: { scope: :similar_sond_id }
  validates :original_song_description, presence: true
  validates :similar_song_description, presence: true

  # def add_song(songs)
end
