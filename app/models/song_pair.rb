class SongPair < ApplicationRecord
  belongs_to :user
  belongs_to :original_song, class_name: 'Song'
  belongs_to :similar_song, class_name: 'Song'
  belongs_to :similarity_category
  
  validates :original_song_id, uniqueness: { scope: :similar_sond_id }
  validates :original_song_description, presence: true
  validates :similar_song_description, presence: true

  accepts_nested_attributes_for :original_song
  accepts_nested_attributes_for :similar_song

  def add_song(song_attributes)
    song = Song.find_or_initialize_by(title: song_attributes[:title])
    song.artists.build if song.artists.empty?
    song.update!(song_attributes)
    return song
  end
end
