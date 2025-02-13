class HomeController < ApplicationController
  skip_before_action :require_login, only: %i[top]

  def top
    # 最近登録された曲
    @recent_song_pairs = SongPair.includes(:similarity_category, original_song: :artists, similar_song: :artists).order(created_at: :desc)

    # 人気曲
    @popularity_song_pairs = SongPair.includes(:similarity_category, original_song: :artists, similar_song: :artists).sort_by { |song_pair| song_pair.page_view_count(request.base_url) }.reverse
  end
end
