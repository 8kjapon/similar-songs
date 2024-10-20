class SongsController < ApplicationController
  def show
    @song = Song.find(params[:id])
  end

  def autocomplete
    query = "%#{params[:query]}%"
    songs = Song.where("title LIKE ?", query).limit(10)
    render json: songs.map { |song|
      {
        title: song.title,
        artists: song.artists.map(&:name).join(','),
        release_date: song.release_date,
        media_url: song.media_url
      }
    }
  end
end
