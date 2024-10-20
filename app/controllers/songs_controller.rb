class SongsController < ApplicationController
  def show
    @song = Song.find(params[:id])
  end

  def autocomplete
    songs = Song.where("title LIKE ?", "%#{params[:query]}%").limit(10)
    render json: songs.pluck(:title)
  end
end
