class SongPairsController < ApplicationController
  before_action :require_login, only: [:create]

  def index
    @q = SongPair.ransack(params[:q])
    @song_pairs = @q.result(distinct: true).includes(:original_song, :similar_song, :similarity_category, :original_song => :artists, :similar_song => :artists).order(created_at: :desc)
  end
  
  def recent_page
    @song_pairs = SongPair.includes(:original_song, :similar_song, :similarity_category, :original_song => :artists, :similar_song => :artists).all.order(created_at: :desc)
  end

  def new
    @song_pair = SongPair.new
    @song_pair.build_original_song
    @song_pair.build_similar_song

    @song_pair.original_song.artists.build if @song_pair.original_song.artists.blank?
    @song_pair.similar_song.artists.build if @song_pair.similar_song.artists.blank?

    @categories = SimilarityCategory.all
  end

  def create
    @song_pair = SongPair.new(song_pair_params)

    ActiveRecord::Base.transaction do
      begin
        # 曲1の保存
        original_song = @song_pair.add_song(song_pair_params[:original_song_attributes])

        # 曲2の保存
        similar_song = @song_pair.add_song(song_pair_params[:similar_song_attributes])

        # 曲ペアの保存
        @song_pair.original_song = original_song
        @song_pair.similar_song = similar_song
        @song_pair.user = current_user

        if @song_pair.save
          redirect_to @song_pair, notice: '曲のペアが登録されました'
        else
          @song_pair.errors.merge!(e.record.errors)
          @categories = SimilarityCategory.all
          render :new, status: :unprocessable_entity
          flash[:alert] = "入力に誤りがあります"
        end

      rescue ActiveRecord::RecordInvalid => e
        # バリデーションエラーが発生した場合にフォームを再表示
        @song_pair.errors.merge!(e.record.errors)
        @categories = SimilarityCategory.all
        render :new, status: :unprocessable_entity
      end
    end
  end

  def show
    @song_pair = SongPair.find(params[:id])
  end

  private

  def song_pair_params
    params.require(:song_pair).permit(
      :original_song_description, :similar_song_description, :similarity_category_id,
      original_song_attributes: [:title, :release_date, :media_url, artists_attributes: [:name]],
      similar_song_attributes: [:title, :release_date, :media_url, artists_attributes: [:name]]
    )
  end
end
