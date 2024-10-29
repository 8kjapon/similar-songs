class ApplicationController < ActionController::Base
  before_action :require_login
  before_action :set_search
  skip_before_action :track_ahoy_visit

  private

  def redirect_if_logged_in
    if logged_in?
      redirect_to root_path, notice: 'すでにログインしています。'
    end
  end

  def set_search
    @q = SongPair.ransack(params[:q])
  end
end
