module Admin
  class ArtistsController < BaseController
    layout 'admin'

    def index
      @artists = Artist.includes(:songs)
    end

    def edit
      @artist = Artist.find(params[:id])
    end

    def update
      @artist = Artist.find(params[:id])
      if @artist.update(artist_params)
        redirect_to admin_artists_path, notice: "アーティスト情報を更新しました"
      else
        flash.now[:alert] = "入力に誤りがあります"
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @artist = Artist.find(params[:id])
      if @artist.songs.presence || @artist.song_pairs.presence
        redirect_to admin_artists_path, alert: "該当アーティストが含まれた似てる曲組み合わせや楽曲が存在します"
      else
        @artist.destroy
        redirect_to admin_artists_path, notice: "削除しました"
      end
    end

    private

    def artist_params
      params.require(:artist).permit(:name)
    end
  end
end
