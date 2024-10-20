class Song < ApplicationRecord
  has_many :song_artists
  has_many :artists, through: :song_artists
  has_many :song_pairs, class_name: "SongPair", foreign_key: :original_song_id
  has_many :similar_song_pairs, class_name: "SongPair", foreign_key: :similar_song_id

  validates :title, presence: true, length: { maximum: 255 }
  validates :media_url, presence: true

  validate :release_date_check

  accepts_nested_attributes_for :artists

  def media_url_id
    extract_media_id(media_url)
  end

  def pair_song_list(similarity_category_id)
    
    # binding.pry
    
  end

  private

  def release_date_check
    if release_date.present?
      if release_date.to_i > Date.today.year
        errors.add(:release_date, "は未来の数値にできません。")
      end
    end
  end

  def extract_media_id(url)
    return nil if url.blank?
    reg_exp = %r{^.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|&v=)([^#\&\?]*).*}
    match = url.match(reg_exp)
    match[2] if match && match[2].length == 11
  end
end
