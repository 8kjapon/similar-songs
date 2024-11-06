class SongPairsController < ApplicationController
  skip_before_action :require_login, only: %i[index show]
  before_action :track_ahoy_visit, only: %i[show]
  before_action :check_login_for_sort_and_filter, only: %i[index]

  def index
    @q = SongPair.ransack(params[:q])
    @song_pairs = @q.result(distinct: true).includes(:similarity_category, :original_song => :artists, :similar_song => :artists)

    @song_pairs = case params[:sort_by]
                  when "song_title"
                    @song_pairs.joins(:original_song).group('song_pairs.id').reorder('songs.title' => params[:order])
                  when "artist_name"
                    if params[:order] == "asc"
                      Kaminari.paginate_array(@song_pairs.sort_by { |song_pair| song_pair.original_song.artist_list.downcase })
                    else
                      Kaminari.paginate_array(@song_pairs.sort_by { |song_pair| song_pair.original_song.artist_list.downcase }.reverse)
                    end
                  when "created_at"
                    @song_pairs.reorder(created_at: params[:order]) 
                  else
                    @song_pairs.order(created_at: :desc)
                  end
                  
    @song_pairs = @song_pairs.page(params[:page])
  end
  
  def recent_page
    @q = SongPair.ransack(params[:q])
    @song_pairs = @q.result(distinct: true).includes(:similarity_category, :original_song => :artists, :similar_song => :artists).order(created_at: :desc).page(params[:page])
  end

  def popularity_page
    @q = SongPair.ransack(params[:q])
    @song_pairs = @q.result(distinct: true).includes(:similarity_category, :original_song => :artists, :similar_song => :artists).sort_by{ |song_pair| song_pair.page_view_count(request.base_url) }.reverse
    @song_pairs = Kaminari.paginate_array(@song_pairs).page(params[:page])
  end

  def new
    @song_pair = SongPair.new
    if params[:original_song_id]
      original_song = Song.find(params[:original_song_id])
      @song_pair.build_original_song(title: original_song.title, release_date: original_song.release_date, media_url: original_song.media_url)
      @song_pair.original_song.artists.build(name: original_song.artist_list)
    else
      @song_pair.build_original_song
      @song_pair.original_song.artists.build if @song_pair.original_song.artists.blank?
    end
    
    @song_pair.build_similar_song
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

  def check_login_for_sort_and_filter
    if params[:sort_by].present? || params[:order].present?
      unless logged_in?
        params.delete(:sort_by)
        params.delete(:order)
        params[:q].delete(:similarity_category_id_eq)
      end
    end
  end
end
