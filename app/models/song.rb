class Song < ApplicationRecord
  has_many :song_artists
  has_many :artists, through: :song_artists
  has_many :song_pairs, class_name: "SongPair", foreign_key: :original_song_id
  has_many :similar_song_pairs, class_name: "SongPair", foreign_key: :similar_song_id

  validates :title, presence: true, length: { maximum: 255 }
  validates :media_url, presence: true, format: { with: %r{\A(https://www\.youtube\.com/watch\?v=|https://youtu\.be/)[\w-]+\z}, message: "は有効なYouTubeリンクである必要があります" }

  validate :release_date_check

  accepts_nested_attributes_for :artists

  def media_url_id
    extract_media_id(media_url)
  end

  def pair_song_list(similarity_category: nil, maximum: 0)
    similarity_category_id = { 'melody' => 1, 'style' => 2, 'sampling' => 3 }

    # 似てる曲(original側)として紐づけられてる曲一覧の取得
    song_list = song_pairs.where(similarity_category_id: similarity_category_id[similarity_category]).map(&:similar_song)

    # 似てる曲(similar側)として紐づけられてる曲一覧の取得
    similar_song_list = similar_song_pairs.where(similarity_category_id: similarity_category_id[similarity_category]).map(&:original_song)

    # 曲一覧の結合と登録日順でソート
    song_list |= similar_song_list
    if maximum.positive?
      song_list.sort_by { |song| -song.created_at.to_i }.take(maximum)
    else
      song_list.sort_by { |song| -song.created_at.to_i }
    end
  end

  def artist_list
    artists.map(&:name).join(', ')
  end

  def song_pair(song)
    if song_pairs.find_by(similar_song_id: song.id).present?
      song_pairs.find_by(similar_song_id: song.id)
    else
      similar_song_pairs.find_by(original_song_id: song.id)
    end
  end

  def self.ransackable_attributes(_auth_object = nil)
    ["title", "artist_list"]
  end

  def self.ransackable_associations(_auth_object = nil)
    ["artists"]
  end

  ransacker :artist_list do
    Arel.sql <<-SQL
    (SELECT GROUP_CONCAT(artists.name SEPARATOR ', ')
    FROM song_artists
    JOIN artists ON song_artists.artist_id = artists.id
    WHERE song_artists.song_id = songs.id
    GROUP BY song_artists.song_id)
    SQL
  end

  private

  def release_date_check
    return unless release_date.present?
    return unless release_date.to_i > Date.today.year

    errors.add(:release_date, "は未来の数値にできません。")
  end

  def extract_media_id(url)
    return nil if url.blank?

    reg_exp = %r{^.*(youtu.be/|v/|u/\w/|embed/|watch\?v=|&v=)([^#\&\?]*).*}
    match = url.match(reg_exp)
    match[2] if match && match[2].length == 11
  end
end
