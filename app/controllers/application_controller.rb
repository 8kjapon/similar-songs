class ApplicationController < ActionController::Base
  before_action :require_login
  before_action :set_search
  skip_before_action :track_ahoy_visit
  before_action :prepare_meta_tags

  private

  # ログイン済みユーザーが必要のない場所にアクセスした場合の処理
  def redirect_if_logged_in
    redirect_to root_path if logged_in?
  end

  # ヘッダー内の検索バーに検索用クエリを与える為の処理
  def set_search
    @q = SongPair.ransack(params[:q])
  end

  def prepare_meta_tags(options = {})
    site_name = "musim"
    title = "『似ている』から始まる曲探し"
    description = "似ている曲から新しい曲への出会いを。"
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
end
