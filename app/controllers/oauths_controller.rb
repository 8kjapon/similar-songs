class OauthsController < ApplicationController
  skip_before_action :require_login, only: %i[oauth callback]
  before_action :redirect_if_logged_in, only: %i[oauth callback]

  def oauth
    login_at(params[:provider])
  end

  def callback
    provider = params[:provider]
    if (@user = login_from(provider))
      @user.update(last_login_at: Time.current)
      redirect_to root_path, notice: t("views.flash_message.notice.oauths.callback.login", provider: provider.titleize)
    else
      begin
        @user = create_from(provider)
        reset_session
        auto_login(@user)
        @user.update(last_login_at: Time.current)
        redirect_to root_path, notice: t("views.flash_message.notice.oauths.callback.login", provider: provider.titleize)
      rescue NoMethodError, OAuth2::Error => e
        Rails.logger.error(e.message)
        redirect_to login_path, alert: t("views.flash_message.notice.oauths.callback.other")
      rescue ActiveRecord::RecordNotUnique => e
        Rails.logger.error(e.message)
        redirect_to login_path, alert: t("views.flash_message.notice.oauths.callback.email")
      end
    end
  end
end
