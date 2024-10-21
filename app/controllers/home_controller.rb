class HomeController < ApplicationController
  def top
    @song_pairs = SongPair.all.order(created_at: :desc)
  end
end
