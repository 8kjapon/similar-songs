class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]
  before_action :redirect_if_logged_in, only: %i[new create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to login_path, notice: 'ユーザー登録が完了しました'
    else
      flash.now[:alert] = "入力に誤りがあります"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user = current_user
    @song_pairs = SongPair.includes(:similarity_category, original_song: :artists, similar_song: :artists).where(user_id: @user.id)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
