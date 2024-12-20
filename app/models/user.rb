class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :song_pairs, dependent: :nullify
  has_many :song_pair_evaluations, dependent: :destroy
  has_many :evaluated_song_pairs, through: :song_pair_evaluations, source: :song_pair
  has_many :contacts, dependent: :nullify
  has_many :authentications, :dependent => :destroy
  accepts_nested_attributes_for :authentications

  validates :name, presence: true, length: { minimum: 3, maximum: 255 }
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, presence: true, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :reset_password_token, presence: true, uniqueness: true, allow_nil: true

  enum :role, { general: 'general', admin: 'admin' }
  validates :role, inclusion: { in: roles.keys }

  # SongPairが評価された場合の処理
  def song_pair_evaluation(song_pair)
    evaluated_song_pairs << song_pair
  end

  # SongPairの評価が取り消された場合の処理
  def song_pair_unevaluation(song_pair)
    evaluated_song_pairs.destroy(song_pair)
  end

  # SongPairが評価されているかを判断する処理
  def song_pair_evaluated?(song_pair)
    evaluated_song_pairs.include?(song_pair)
  end

  # 評価済みのSongPairを評価日時の降順で出力する処理
  def evaluated_song_pairs_ordered
    evaluated_song_pairs.select('song_pairs.*, MAX(song_pair_evaluations.created_at) AS evaluation_date').joins(:song_pair_evaluations).group('song_pairs.id').order('evaluation_date DESC')
  end

  # SongPairの登録者かどうかを判断する処理
  def song_pair_own?(song_pair)
    song_pairs.include?(song_pair)
  end

  # 管理者識別用の処理
  def admin?
    role == 'admin'
  end
end
