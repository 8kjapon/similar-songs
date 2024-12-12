module Admin
  class SongPairsController < BaseController
    layout 'admin'

    def index
      @song_pairs = SongPair.includes(:similarity_category, original_song: :artists, similar_song: :artists)
    end

    def edit
      @song_pair = SongPair.find(params[:id])
      @categories = similarity_category
    end

    def update
      @song_pair = SongPair.find(params[:id])
      if @song_pair.update(song_pair_params)
        redirect_to admin_song_pairs_path, notice: "楽曲情報を更新しました"
      else
        @categories = similarity_category
        flash.now[:alert] = "入力に誤りがあります"
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @song_pair = SongPair.find(params[:id])
      @song_pair.destroy
      redirect_to admin_song_pairs_path, notice: "削除しました"
    end

    private

    def song_pair_params
      params.require(:song_pair).permit(:original_song_description, :similar_song_description, :similarity_category_id)
    end
  end
end
