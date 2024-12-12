class Song < ApplicationRecord
  has_many :song_artists, dependent: :destroy
  has_many :artists, through: :song_artists
  has_many :song_pairs, class_name: "SongPair", foreign_key: :original_song_id, inverse_of: :original_song, dependent: :nullify
  has_many :similar_song_pairs, class_name: "SongPair", foreign_key: :similar_song_id, inverse_of: :similar_song, dependent: :nullify

  validates :title, presence: true, length: { maximum: 255 }
  # validates :media_url, presence: true, format: { with: %r{\A(https://www\.youtube\.com/watch\?v=|https://youtu\.be/)[\w-]+\z} }
  validate :media_url_format
  validate :release_date_check

  accepts_nested_attributes_for :artists

  # 記録されてるYouTubeのURLからID部分を抽出
  def media_url_id
    extract_media_id(media_url)
  end

  # 該当する曲と関連する似てる曲・サンプリング曲の一覧を取得
  def pair_song_list(similarity_category: nil, maximum: 0)
    # similarity_categoryのidを引数で受け取ったカテゴリー名から指定できるようにハッシュを設定
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

  # 該当する曲と紐づけられたアーティストの一覧をコンマ区切りで出力
  def artist_list
    artists.map(&:name).join(', ')
  end

  # 該当する曲の含まれる似てる曲・サンプリング曲の組み合わせ(SongPair)を取得
  def song_pair(song)
    song_pairs.find_by(similar_song_id: song.id).presence || similar_song_pairs.find_by(original_song_id: song.id)
  end

  def song_pairs_count
    song_pairs.count + similar_song_pairs.count
  end

  # ransackでの検索対象カラムを設定
  def self.ransackable_attributes(_auth_object = nil)
    ["title"]
  end

  # ransackで関連するデータを検索対象にできるように設定
  def self.ransackable_associations(_auth_object = nil)
    ["artists"]
  end

  private

  # リリース年が正常な数値かチェックする処理
  def release_date_check
    # リリース年が未入力、未来を指す数値でない場合は処理を終了
    return if release_date.blank?
    return unless release_date.to_i > Time.zone.today.year

    # リリース年が未来を指す数値の場合にエラーを追加
    errors.add(:release_date, "は未来の数値にできません。")
  end

  # 引数として受け取ったYouTubeのURLからID部分を抽出する処理
  def extract_media_id(url)
    # 引数がブランクな値であれば処理を終了
    return nil if url.blank?

    # 正規表現を使用してIDを抽出
    reg_exp = %r{^.*(youtu.be/|v/|u/\w/|embed/|watch\?v=|&v=)([^#\&\?]*).*}
    match = url.match(reg_exp)
    match[2] if match && match[2].length == 11
  end

  # メディアURLの形式と空欄であるかどうかをチェック
  def media_url_format
    # URLが入力されており、形式が正しい場合は処理を終了
    return if media_url.present? && media_url.match?(%r{\A(https://www\.youtube\.com/watch\?v=|https://youtu\.be/)([\w-]{11})\z})

    errors.add(:media_url, I18n.t('errors.messages.invalid_media_url'))
  end
end
