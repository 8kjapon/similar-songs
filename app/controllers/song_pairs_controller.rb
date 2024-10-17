class SongPairsController < ApplicationController
  before_action :require_login, only: [:create]

  def index
    @song_pairs = SongPair.all
  end
  
  def new
    @song_pair = SongPair.new
    @song_pair.build_original_song
    @song_pair.build_similar_song
    @categories = SimilarityCategory.all
  end

  def create
    @song_pair = SongPair.new(song_pair_params)

    ActiveRecord::Base.transaction do
      # 曲1の保存
      original_song = @song_pair.add_song(song_pair_params[:original_song_attributes])

      # アーティスト1の保存
      artist1 = Artist.find_or_create_by!(name: song_pair_params[:original_song_artist_attributes][:name])
      SongArtist.find_or_create_by!(song: original_song, artist: artist1)

      # 曲2の保存
      similar_song = @song_pair.add_song(song_pair_params[:similar_song_attributes])

      # アーティスト2の保存
      artist2 = Artist.find_or_create_by!(name: song_pair_params[:similar_song_artist_attributes][:name])
      SongArtist.find_or_create_by!(song: similar_song, artist: artist2)

      # 曲ペアの保存
      @song_pair.original_song = original_song
      @song_pair.similar_song = similar_song
      @song_pair.user = current_user

      @song_pair.save!
    end

    redirect_to @song_pair, notice: '曲のペアが登録されました'
  rescue ActiveRecord::RecordInvalid
    @categories = SimilarityCategory.all
    render :new, status: :unprocessable_entity
  end

  def show
  end

  private

  def song_pair_params
    params.require(:song_pair).permit(
      :original_song_description, :similar_song_description, :similarity_category_id,
      original_song_attributes: [:title, :release_date, :media_url, artist_attributes: [:name]],
      similar_song_attributes: [:title, :release_date, :media_url, artist_attributes: [:name]]
    )
  end
end
