class UserSessionsController < ApplicationController
  # skip_before_action :require_login, only: %i[new create]
  before_action :redirect_if_logged_in, only: %i[new create]

  def new; end

  def create
    @user = login(params[:email], params[:password])
    if @user
      redirect_to root_path, notice: 'ログインしました'
    else
      flash.now[:alert] = 'メールアドレスまたはパスワードが正しくありません。'
      render :new
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: 'ログインしました。', status: :see_other
  end
end