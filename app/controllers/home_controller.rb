class HomeController < ApplicationController
  skip_before_action :require_login, only: %i[top]
  
  def top
    @song_pairs = SongPair.includes(:similarity_category, :original_song => :artists, :similar_song => :artists).order(created_at: :desc)
  end
end
