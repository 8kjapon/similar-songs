class ArtistsController < ApplicationController
  def autocomplete
    artists = Artist.where("name LIKE ?", "%#{params[:query]}%").limit(10)
    render json: artists.pluck(:name)
  end
end
