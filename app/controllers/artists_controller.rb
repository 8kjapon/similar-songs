class ArtistsController < ApplicationController
  def autocomplete
    query = "%#{params[:query]}%"
    artists = Artist.where("name LIKE ?", query).limit(10)
    render json: artists.pluck(:name)
  end
end
