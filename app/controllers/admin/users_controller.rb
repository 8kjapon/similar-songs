module Admin
  class UsersController < BaseController
    layout 'admin'

    def index
      @users = User.includes(:song_pairs)
    end

    def song_pairs
      @user = User.find(params[:id])
      @song_pairs = @user.song_pairs
    end

    def edit
      @user = User.find(params[:id])
    end

    def update
      @user = User.find(params[:id])
      if @user.update(user_params)
        redirect_to admin_users_path, notice: "ユーザー情報を更新しました"
      else
        flash.now[:alert] = "入力に誤りがあります"
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @user = User.find(params[:id])
      @user.destroy
      redirect_to admin_users_path, notice: "削除しました"
    end

    private

    def user_params
      params.require(:user).permit(:role)
    end
  end
end
