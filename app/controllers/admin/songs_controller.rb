module Admin
  class SongsController < BaseController
    layout 'admin'

    def index
      @songs = Song.includes(:song_pairs, :artists)
    end

    def edit
      @song = Song.find(params[:id])
    end

    def update
      @song = Song.find(params[:id])
      if @song.update(song_params)
        redirect_to admin_songs_path, notice: "楽曲情報を更新しました"
      else
        flash.now[:alert] = "入力に誤りがあります"
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @song = Song.find(params[:id])
      if @song.song_pairs.presence || @song.similar_song_pairs.presence
        redirect_to admin_songs_path, alert: "該当楽曲が含まれた似てる曲組み合わせが存在します: #{@song.song_pairs_count}件"
      else
        @song.destroy
        redirect_to admin_songs_path, notice: "削除しました"
      end
    end

    private

    def song_params
      params.require(:song).permit(:title, :release_date, :media_url)
    end
  end
end
