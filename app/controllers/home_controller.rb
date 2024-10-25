class HomeController < ApplicationController
  skip_before_action :require_login, only: %i[top]
  
  def top
    @song_pairs = SongPair.all.order(created_at: :desc)
  end
end
