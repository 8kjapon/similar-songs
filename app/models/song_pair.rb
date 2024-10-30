class SongPair < ApplicationRecord
  belongs_to :user
  belongs_to :original_song, class_name: 'Song'
  belongs_to :similar_song, class_name: 'Song'
  belongs_to :similarity_category
  has_many :song_pair_evalutions, dependencies: :destroy
  
  validates :original_song_id, uniqueness: { scope: :similar_song_id }
  validates :original_song_description, presence: true
  validates :similar_song_description, presence: true

  accepts_nested_attributes_for :original_song
  accepts_nested_attributes_for :similar_song

  def add_song(song_attributes)
    # 曲の保存
    song = Song.find_or_initialize_by(title: song_attributes[:title])
    song.update!(song_attributes.except(:artists_attributes))

    # アーティストの保存
    song_attributes[:artists_attributes].each do |_, artist_attributes|
      artist = Artist.find_or_create_by!(name: artist_attributes[:name])
      SongArtist.find_or_create_by!(song: song, artist: artist)
    end
    return song
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "original_song_id", "similar_song_id", "similarity_category_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["original_song", "similar_song", "similarity_category"]
  end

  def page_view_count(base_url)
    url = "#{base_url}/song_pairs/#{id}"
    Ahoy::Visit.where(landing_page: url).count
  end
end
