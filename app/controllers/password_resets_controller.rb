class PasswordResetsController < ApplicationController
  skip_before_action :require_login
  before_action :redirect_if_logged_in

  def new; end

  def edit
    @user = User.load_from_reset_password_token(params[:id])
    not_authenticated unless @user
  end

  def create
    if params[:email].empty?
      flash.now[:alert] = t("views.flash_message.alert.password_resets.email")
      render :new, status: :unprocessable_entity
    else
      @user = User.find_by(email: params[:email])
      @user&.deliver_reset_password_instructions!
      redirect_to login_path, notice: t("views.flash_message.notice.password_resets.create")
    end
  end

  def update
    @user = User.load_from_reset_password_token(params[:id])
    not_authenticated unless @user

    if @user.update(password_params) && password_params[:password].presence
      redirect_to login_path, notice: t("views.flash_message.notice.password_resets.update")
    else
      flash.now[:alert] = t("views.flash_message.alert.form_error")
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
