class ApplicationController < ActionController::Base
  before_action :require_login
  before_action :set_search
  before_action :check_login_history, if: -> { logged_in? }
  skip_before_action :track_ahoy_visit
  before_action :prepare_meta_tags

  private

  def not_authenticated
    flash[:alert] = "ログインが必要です"
    redirect_to login_path
  end

  # ログイン済みユーザーが必要のない場所にアクセスした場合の処理
  def redirect_if_logged_in
    redirect_to root_path if logged_in?
  end

  # ヘッダー内の検索バーに検索用クエリを与える為の処理
  def set_search
    @q = SongPair.ransack(params[:q])
  end

  def prepare_meta_tags(options = {})
    site_name = t("meta_tags.site_name")
    title = t("meta_tags.title")
    description = t("meta_tags.description")
    current_url = request.original_url

    defaults = {
      site: site_name,
      title: title,
      description: description,
      keywords: ['music', 'similar', 'songs'],
      og: {
        url: current_url,
        site_name: site_name,
        title: title,
        description: description,
        type: "website",
        image: view_context.asset_url("og.jpg")
      }
    }

    options.reverse_merge!(defaults)

    set_meta_tags(options)
  end

  # 似てるカテゴリーをi18nで翻訳後に格納して出力する処理
  def similarity_category
    SimilarityCategory.all.map do |category|
      category.name = t("similarity_category.#{category.name}")
      category
    end
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

  # ログイン履歴が存在していない場合に記録
  def check_login_history
    # ログイン履歴が存在している場合は処理をスキップ
    return if current_user.last_login_at.presence

    current_user.update(last_login_at: Time.current)
  end
end
