class Artist < ApplicationRecord
  has_many :song_artists, dependent: :nullify
  has_many :songs, through: :song_artists

  validates :name, presence: true, length: { maximum: 255 }

  # 該当アーティストの含まれるSongPairの数を取得
  def song_pairs
    result = []
    songs.each do |song|
      # データの取得
      pairs = song.song_pairs + song.similar_song_pairs

      # 同じアーティストの楽曲の組み合わせがあった場合は重複しないように1つとしてカウント
      result += pairs
    end
    result.uniq
  end
end
