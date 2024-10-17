class SongPairsController < ApplicationController
  before_action :require_login, only: [:create]

  def index
    @song_pairs = SongPair.all
  end
  
  def new
    @song_pair = SongPair.new
  end

  def create
    # @song_pair = current_user.song_pairs.new(song_pair_params)

    # if @song_pair.save
    #   redirect_to @song_pair, 
    # end
  end

  def show
  end

  # private

  # def song_pair_params
  #   params.require(:song_pair).permit(:original_song_description, :similar_song_description)
  # end
end
