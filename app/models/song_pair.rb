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
    # 既存のデータとして存在するかチェック
    existing_song = Song.joins(:artists).where(
      title: song_attributes[:title],
      artists: { name: song_attributes[:artists_attributes].values.map { |a| a[:name] } }
    ).first

    # 既存のデータがあればそちらを、なければ新規でデータを作成
    song = existing_song || Song.new(title: song_attributes[:title], release_date: song_attributes[:release_date])

    # 新規作成の場合は楽曲データを保存
    if song.new_record?
      song.assign_attributes(song_attributes.except(:artists_attributes))
      song.save!
    end

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
    ["created_at", "original_song_id", "similar_song_id", "similarity_category_id", "original_song_artist_list", "similar_song_artist_list"]
  end

  # ransackで関連するデータを検索対象にできるように設定
  def self.ransackable_associations(_auth_object = nil)
    ["original_song", "similar_song", "similarity_category"]
  end

  # ransackでoriginal_song_artist_listからアーティスト一覧を取得出来るように設定
  ransacker :original_song_artist_list do
    Arel.sql <<-SQL.squish
    (SELECT GROUP_CONCAT(artists.name SEPARATOR ', ')
    FROM song_artists
    JOIN artists ON song_artists.artist_id = artists.id
    WHERE song_artists.song_id = song_pairs.original_song_id
    GROUP BY song_artists.song_id)
    SQL
  end

  # ransackでsimilar_song_artist_listからアーティスト一覧を取得出来るように設定
  ransacker :similar_song_artist_list do
    Arel.sql <<-SQL.squish
    (SELECT GROUP_CONCAT(artists.name SEPARATOR ', ')
    FROM song_artists
    JOIN artists ON song_artists.artist_id = artists.id
    WHERE song_artists.song_id = song_pairs.similar_song_id
    GROUP BY song_artists.song_id)
    SQL
  end

  # 該当するSongPairの閲覧数を出力する処理
  def page_view_count(base_url)
    url = "#{base_url}/song_pairs/#{id}"

    # Ahoyで記録された閲覧記録から該当するURLページへの閲覧(アクセス)数を取得
    Ahoy::Visit.where(landing_page: url).count
  end

  # カテゴリー名をI18nによる翻訳を行い出力
  def similarity_category_name
    I18n.t("similarity_category.#{similarity_category.name}")
  end
  
  # 関連するモデルも含めた全バリデーションチェック
  def validate_associated_songs_and_artists
    validate_songs_and_artists(original_song, "曲情報1", :original_song_description)
    validate_songs_and_artists(similar_song, "曲情報2", :similar_song_description)
    
    # エラーが発生した場合は保存処理の中止
    raise ActiveRecord::RecordInvalid.new(self) if errors.any?
  end
  
  private

  # 楽曲とそのアーティストに関するバリデーションチェックを行う処理
  def validate_songs_and_artists(song, song_label, song_description)
    # 問題があればエラーに追加
    unless song.valid?
      song.errors.full_messages.uniq.each do |message|
        error_message = "#{song_label}の#{message}"
        errors.add(:base, error_message) unless errors[:base].include?(error_message)
      end
    end

    # 楽曲説明のチェック
    errors.add(song_description, "#{song_label}#{I18n.t("errors.messages.blank_song_description")}") if send(song_description).blank?
  end
end
