module Admin
  class UsersController < BaseController
    layout 'admin'

    def index
      @users = User.includes(:song_pairs)
    end

    def destroy
      @user = User.find(params[:id])
      @user.destroy
      redirect_to admin_users_path, notice: "削除しました"
    end
  end
end
