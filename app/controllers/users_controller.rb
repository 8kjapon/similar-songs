class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]
  before_action :redirect_if_logged_in, only: %i[new create]

  def show
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

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to login_path, notice: 'ユーザー登録が完了しました'
    else
      flash.now[:alert] = "入力に誤りがあります"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
