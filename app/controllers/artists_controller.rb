class ArtistsController < ApplicationController
  # 楽曲登録フォームのオートコンプリート機能用の処理
  def autocomplete
    query = "%#{params[:query]}%"
    artists = Artist.where("name LIKE ?", query).limit(10)
    render json: artists.pluck(:name)
  end
end
