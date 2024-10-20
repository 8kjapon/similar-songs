class Song < ApplicationRecord
  has_many :song_artists
  has_many :artists, through: :song_artists
  has_many :song_pair

  validates :title, presence: true, length: { maximum: 255 }
  validates :media_url, presence: true

  validate :release_date_check

  accepts_nested_attributes_for :artists

  private

  def release_date_check
    if release_date.present?
      if release_date.to_i > Date.today.year
        errors.add(:release_date, "は未来の数値にできません。")
      end
    end
  end
end
