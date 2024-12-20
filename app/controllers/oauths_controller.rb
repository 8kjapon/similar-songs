class OauthsController < ApplicationController
  skip_before_action :require_login, only: %i[oauth callback]
  before_action :redirect_if_logged_in, only: %i[oauth callback]

  def oauth
    login_at(params[:provider])
  end

  def callback
    provider = params[:provider]
    if @user = login_from(provider)
      redirect_to root_path, notice: "#{provider.titleize}でログインしました"
    else
      begin
        @user = create_from(provider)
        reset_session
        auto_login(@user)
        redirect_to root_path, notice: "#{provider.titleize}でログインしました"
      rescue
        redirect_to login_path, alert: "ログインに失敗しました"
      end
  end
end
