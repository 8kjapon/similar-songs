class ApplicationController < ActionController::Base
  before_action :require_login
  before_action :set_search
  skip_before_action :track_ahoy_visit

  private

  # ログイン済みユーザーが必要のない場所にアクセスした場合の処理
  def redirect_if_logged_in
    redirect_to root_path if logged_in?
  end

  # ヘッダー内の検索バーに検索用クエリを与える為の処理
  def set_search
    @q = SongPair.ransack(params[:q])
  end
end
