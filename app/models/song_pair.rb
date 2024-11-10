class SongPair < ApplicationRecord
  belongs_to :user
  belongs_to :original_song, class_name: 'Song'
  belongs_to :similar_song, class_name: 'Song'
  belongs_to :similarity_category
  has_many :song_pair_evaluations, dependent: :destroy

  validates :original_song_id, uniqueness: { scope: :similar_song_id }
  validates :original_song_description, presence: true
  validates :similar_song_description, presence: true

  accepts_nested_attributes_for :original_song
  accepts_nested_attributes_for :similar_song

  # 引数で受け取った楽曲・アーティスト情報を記録する処理
  def add_song(song_attributes)
    # 曲の保存
    song = Song.find_or_initialize_by(title: song_attributes[:title])
    song.update!(song_attributes.except(:artists_attributes))

    # アーティストの保存
    song_attributes[:artists_attributes].each_value do |artist_attributes|
      artist = Artist.find_or_create_by!(name: artist_attributes[:name])
      SongArtist.find_or_create_by!(song: song, artist: artist)
    end

    # 記録した楽曲のデータを返す
    song
  end

  # ransackでの検索対象カラムを設定
  def self.ransackable_attributes(_auth_object = nil)
    ["created_at", "original_song_id", "similar_song_id", "similarity_category_id"]
  end

  # ransackで関連するデータを検索対象にできるように設定
  def self.ransackable_associations(_auth_object = nil)
    ["original_song", "similar_song", "similarity_category"]
  end

  # 該当するSongPairの閲覧数を出力する処理
  def page_view_count(base_url)
    url = "#{base_url}/song_pairs/#{id}"

    # Ahoyで記録された閲覧記録から該当するURLページへの閲覧(アクセス)数を取得
    Ahoy::Visit.where(landing_page: url).count
  end
end
