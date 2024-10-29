class SongsController < ApplicationController
  skip_before_action :require_login, only: %i[show melody_song_pairs style_song_pairs sampling_song_pairs]

  def show
    @song = Song.find(params[:id])
  end

  def melody_song_pairs
    @song = Song.includes(:artists, :song_pairs).find(params[:id])
    unless @song.melody_pairs.count > 3
      redirect_to song_path
    end
  end

  def style_song_pairs
    @song = Song.includes(:artists, :song_pairs).find(params[:id])
    unless @song.style_pairs.count > 3
      redirect_to song_path
    end
  end

  def sampling_song_pairs
    @song = Song.includes(:artists, :song_pairs).find(params[:id])
    unless @song.sampling_pairs.count > 3
      redirect_to song_path
    end
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
