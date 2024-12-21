class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]
  before_action :redirect_if_logged_in, only: %i[new create]
  before_action :redirect_if_oauth_user, only: %i[edit_email edit_password update_email update_password]

  def mypage
    @user = current_user
    @song_pairs = @user.song_pairs.includes(:similarity_category, original_song: :artists, similar_song: :artists).order(created_at: :desc)
    @evaluated_song_pairs = @user.evaluated_song_pairs.merge(SongPairEvaluation.order(created_at: :desc)).includes(:similarity_category, original_song: :artists, similar_song: :artists)
  end

  def submit_songs
    @user = current_user
    @q = @user.song_pairs.ransack(params[:q])
    @song_pairs = @q.result(distinct: true).includes(:similarity_category, original_song: :artists, similar_song: :artists).page(params[:page])
    @categories = similarity_category

    # データの並べ替え
    @song_pairs = sort_song_pairs(@song_pairs).page(params[:page])
  end

  def evaluated_songs
    @user = current_user
    @q = @user.evaluated_song_pairs_ordered.ransack(params[:q])
    @evaluated_song_pairs = @q.result(distinct: true).includes(:similarity_category, original_song: :artists, similar_song: :artists).page(params[:page])
    @categories = similarity_category
  end

  def new
    @user = User.new
  end

  def edit
    @user = current_user
  end

  def edit_email
    @user = current_user
  end

  def edit_password
    @user = current_user
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to login_path, notice: t("views.flash_message.notice.user.submit")
    else
      flash.now[:alert] = t("views.flash_message.alert.form_error")
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @user = current_user
    if @user.update(user_update_params)
      redirect_to mypage_path, notice: t("views.flash_message.notice.user.update")
    else
      flash.now[:alert] = t("views.flash_message.alert.form_error")
      render :edit, status: :unprocessable_entity
    end
  end

  def update_email
    @user = current_user
    # パスワード認証
    unless @user.valid_password?(user_email_params[:password])
      flash.now[:alert] = t("views.flash_message.alert.user.password")
      render :edit_email, status: :unprocessable_entity
      return
    end

    # メールアドレス検証
    if @user.email == user_email_params[:new_email]
      flash.now[:alert] = t("views.flash_message.alert.user.change_email")
      render :edit_email, status: :unprocessable_entity
      return
    end

    if @user.update(email: user_email_params[:new_email])
      redirect_to mypage_path, notice: t("views.flash_message.notice.user.update")
    else
      flash.now[:alert] = t("views.flash_message.alert.form_error")
      render :edit_email, status: :unprocessable_entity
    end
  end

  def update_password
    @user = current_user
    unless @user.valid_password?(user_password_params[:current_password])
      flash.now[:alert] = t("views.flash_message.alert.user.change_password")
      render :edit_password, status: :unprocessable_entity
      return
    end

    @user.password_confirmation = user_password_params[:password_confirmation]
    if user_password_params[:password].presence && @user.change_password(user_password_params[:password])
      redirect_to mypage_path, notice: t("views.flash_message.notice.user.update")
    else
      flash.now[:alert] = t("views.flash_message.alert.form_error")
      render :edit_password, status: :unprocessable_entity
    end
  end

  private

  def user_email_params
    params.require(:user).permit(:new_email, :password)
  end

  def user_password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def user_update_params
    params.require(:user).permit(:name)
  end

  def redirect_if_oauth_user
    redirect_to mypage_path if current_user.oauth?
  end
end
