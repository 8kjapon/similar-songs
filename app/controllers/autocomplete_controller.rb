class AutocompleteController < ApplicationController
  skip_before_action :require_login, only: %i[search]

  # 検索フォーム用の処理
  def search
    songs = Song.where("title LIKE ?", "%#{params[:q]}%")
    artists = Artist.where("name LIKE ?", "%#{params[:q]}%")

    results = songs.map { |song| { id: song.id, text: "#{song.title} - 楽曲", label: song.title } } +
              artists.map { |artist| { id: artist.id, text: "#{artist.name} - アーティスト", label: artist.name } }

    render partial: "search", locals: { results: results }
  end

  # 楽曲登録フォームの楽曲用の処理
  def songs
    query = "%#{params[:q]}%"
    songs = Song.where("title LIKE ?", query).limit(10)
    results = songs.map do |song|
      {
        id: song.id,
        text: "#{song.title} - #{song.artists.map(&:name).join(', ')}",
        label: song.title,
        artist: song.artists.map(&:name).join(", "),
        release_date: song.release_date,
        media_url: song.media_url
      }
    end

    render partial: "autocomplete/song_submit", locals: { results: results }
  end

  # 楽曲登録フォームのアーティスト用の処理
  def artists
    query = "%#{params[:q]}%"
    artists = Artist.where("name LIKE ?", query).limit(10)

    results = artists.map { |artist| { id: artist.id, text: artist.name } }
    render partial: "artist", locals: { results: results }
  end
end
