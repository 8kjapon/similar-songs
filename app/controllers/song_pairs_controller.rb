class SongPairsController < ApplicationController
  skip_before_action :require_login, only: %i[index show autocomplete]
  before_action :track_ahoy_visit, only: %i[show]
  before_action :check_login_for_sort_and_filter, only: %i[index]

  def index
    @q = SongPair.ransack(params[:q])
    @song_pairs = @q.result(distinct: true).includes(:similarity_category, original_song: :artists, similar_song: :artists)
    @categories = similarity_category

    # データの並べ替え
    @song_pairs = sort_song_pairs(@song_pairs).page(params[:page])
  end

  # 最近登録された曲ページ
  def recent_page
    @q = SongPair.ransack(params[:q])
    @song_pairs = @q.result(distinct: true).includes(:similarity_category, original_song: :artists, similar_song: :artists).order(created_at: :desc).page(params[:page])
    @categories = similarity_category
  end

  # 人気曲ページ
  def popularity_page
    @q = SongPair.ransack(params[:q])
    @song_pairs = @q.result(distinct: true).includes(:similarity_category, original_song: :artists, similar_song: :artists)
    @categories = similarity_category

    # ページのビュー数順に降順でソート
    @song_pairs = @song_pairs.sort_by { |song_pair| song_pair.page_view_count(request.base_url) }.reverse

    # 配列をkaminariでページネーション出来るように変換して設定
    @song_pairs = Kaminari.paginate_array(@song_pairs).page(params[:page])
  end

  def show
    @song_pair = SongPair.find(params[:id])
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

    @categories = similarity_category

    # ステップ入力のスタート時ステップの設定(0 = 注意事項ページ)
    @current_step = 0
  end

  def edit
    @song_pair = SongPair.find(params[:id])
    @categories = similarity_category
    redirect_to @song_pair, alert: "編集権限がありません" unless @song_pair.user == current_user
  end

  def create
    @song_pair = SongPair.new(song_pair_params)

    # SongPairとそれに関連するデータの保存に失敗した場合にエラーを検出
    ActiveRecord::Base.transaction do
      # 関連データのバリデーションを事前チェック
      @song_pair.validate_associated_songs_and_artists

      # 曲1の保存
      original_song = @song_pair.add_song(song_pair_params[:original_song_attributes])

      # 曲2の保存
      similar_song = @song_pair.add_song(song_pair_params[:similar_song_attributes])

      # 曲ペアの保存
      @song_pair.original_song = original_song
      @song_pair.similar_song = similar_song
      @song_pair.user = current_user

      redirect_to @song_pair, notice: '楽曲が登録されました' if @song_pair.save!
    rescue ActiveRecord::RecordInvalid => e
      # エラーメッセージを設定
      @song_pair.errors.merge!(e.record.errors)
      @categories = similarity_category

      # 楽曲情報入力ステップから再開出来るようにステップの設定
      @current_step = 2

      flash.now[:alert] = "入力に誤りがあります"
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @song_pair = SongPair.find(params[:id])
    redirect_to @song_pair, alert: "編集権限がありません" unless @song_pair.user == current_user
    if @song_pair.update(song_pair_update_params)
      redirect_to @song_pair, notice: "楽曲情報を更新しました"
    else
      @categories = similarity_category
      flash.now[:alert] = "入力に誤りがあります"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @song_pair = SongPair.find(params[:id])
    redirect_to @song_pair, alert: "編集権限がありません" unless @song_pair.user == current_user

    @song_pair.destroy
    redirect_to root_path, notice: "曲情報を削除しました"
  end

  # 検索フォームのオートコンプリート用処理
  def autocomplete
    query = params[:q] || ""
    songs = Song.where("title LIKE ?", "%#{query}%")
    artists = Artist.where("name LIKE ?", "%#{query}%")

    results = songs.map { |song| { id: song.id, text: "#{song.title} - 楽曲", label: "#{song.title}" } } +
              artists.map { |artist| { id: artist.id, text: "#{artist.name} - アーティスト", label: "#{artist.name}" } }

    render partial: "autocomplete_results", locals: { results: results }
  end

  private

  def song_pair_params
    params.require(:song_pair).permit(
      :original_song_description, :similar_song_description, :similarity_category_id,
      original_song_attributes: [:title, :release_date, :media_url, { artists_attributes: [:name] }],
      similar_song_attributes: [:title, :release_date, :media_url, { artists_attributes: [:name] }]
    )
  end

  def song_pair_update_params
    params.require(:song_pair).permit(:original_song_description, :similar_song_description, :similarity_category_id)
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
end
