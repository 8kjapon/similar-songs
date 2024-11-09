class SongPairsController < ApplicationController
  skip_before_action :require_login, only: %i[index show]
  before_action :track_ahoy_visit, only: %i[show]
  before_action :check_login_for_sort_and_filter, only: %i[index]

  def index
    @q = SongPair.ransack(params[:q])
    @song_pairs = @q.result(distinct: true).includes(:similarity_category, original_song: :artists, similar_song: :artists)

    # データの並べ替え
    @song_pairs = sort_song_pairs(@song_pairs).page(params[:page])
  end

  # 最近登録された曲ページ
  def recent_page
    @q = SongPair.ransack(params[:q])
    @song_pairs = @q.result(distinct: true).includes(:similarity_category, original_song: :artists, similar_song: :artists).order(created_at: :desc).page(params[:page])
  end

  # 人気曲ページ
  def popularity_page
    @q = SongPair.ransack(params[:q])
    @song_pairs = @q.result(distinct: true).includes(:similarity_category, original_song: :artists, similar_song: :artists)

    # ページのビュー数順に降順でソート
    @song_pairs = @song_pairs.sort_by { |song_pair| song_pair.page_view_count(request.base_url) }.reverse

    # 配列をkaminariでページネーション出来るように変換して設定
    @song_pairs = Kaminari.paginate_array(@song_pairs).page(params[:page])
  end

  def new
    @song_pair = SongPair.new

    # 楽曲ページなどから楽曲情報(params[:original_song_id])を付随して登録ページにアクセスした場合は事前に曲情報1に情報を入力
    if params[:original_song_id]
      original_song = Song.find(params[:original_song_id])
      @song_pair.build_original_song(title: original_song.title, release_date: original_song.release_date, media_url: original_song.media_url)
      @song_pair.original_song.artists.build(name: original_song.artist_list)
    else
      @song_pair.build_original_song
      @song_pair.original_song.artists.build if @song_pair.original_song.artists.blank?
    end

    @song_pair.build_similar_song
    @song_pair.similar_song.artists.build if @song_pair.similar_song.artists.blank?

    @categories = SimilarityCategory.all

    # ステップ入力のスタート時ステップの設定(0 = 注意事項ページ)
    @current_step = 0
  end

  def create
    @song_pair = SongPair.new(song_pair_params)

    # SongPairとそれに関連するデータの保存に失敗した場合にエラーを検出
    ActiveRecord::Base.transaction do
      # 曲1の保存
      original_song = @song_pair.add_song(song_pair_params[:original_song_attributes])

      # 曲2の保存
      similar_song = @song_pair.add_song(song_pair_params[:similar_song_attributes])

      # 曲ペアの保存
      @song_pair.original_song = original_song
      @song_pair.similar_song = similar_song
      @song_pair.user = current_user

      redirect_to @song_pair, notice: '曲のペアが登録されました' if @song_pair.save
    rescue ActiveRecord::RecordInvalid => e
      # エラーメッセージを設定
      @song_pair.errors.merge!(e.record.errors)
      @categories = SimilarityCategory.all

      # 楽曲情報入力ステップから再開出来るようにステップの設定
      @current_step = 2

      flash.now[:alert] = "入力に誤りがあります"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @song_pair = SongPair.find(params[:id])
  end

  private

  def song_pair_params
    params.require(:song_pair).permit(
      :original_song_description, :similar_song_description, :similarity_category_id,
      original_song_attributes: [:title, :release_date, :media_url, { artists_attributes: [:name] }],
      similar_song_attributes: [:title, :release_date, :media_url, { artists_attributes: [:name] }]
    )
  end

  # 未ログインユーザーが検索ページの並べ替え機能などを使用出来ないように制限する処理
  def check_login_for_sort_and_filter
    # 並べ替え機能を使用していない場合やログイン済みユーザーであれば処理をしない
    return unless params[:sort_by].present? || params[:order].present?
    return if logged_in?

    # 送信された並べ替え機能用のパラメーターなどを除去
    params.delete(:sort_by)
    params.delete(:order)
    params[:q].delete(:similarity_category_id_eq)
  end

  # 検索ページの並べ替え機能用の処理
  def sort_song_pairs(song_pairs)
    # 並べ替え用のパラメーターを元に処理を決定
    case params[:sort_by]
    when "song_title" # 曲名順
      song_pairs.joins(:original_song).group('song_pairs.id').reorder('songs.title' => params[:order])
    when "artist_name" # アーティスト名順
      # 並び順(params[:order])に合わせて並べ替え
      if params[:order] == "asc"
        Kaminari.paginate_array(song_pairs.sort_by { |song_pair| song_pair.original_song.artist_list.downcase })
      else
        Kaminari.paginate_array(song_pairs.sort_by { |song_pair| song_pair.original_song.artist_list.downcase }.reverse)
      end
    when "created_at" # 登録日順
      song_pairs.reorder(created_at: params[:order])
    else
      song_pairs.order(created_at: :desc)
    end
  end
end
