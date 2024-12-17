class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]
  before_action :redirect_if_logged_in, only: %i[new create]

  def new; end

  def create
    @user = login(params[:email], params[:password])
    if @user
      @user.update(last_login_at: Time.current)
      redirect_to root_path, notice: t("views.flash_message.notice.user_sessions.login")
    else
      flash.now[:alert] = t("views.flash_message.alert.user_sessions")
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: t("views.flash_message.notice.user_sessions.logout"), status: :see_other
  end
end
