class SongsController < ApplicationController
  skip_before_action :require_login, only: %i[show melody_song_pairs style_song_pairs sampling_song_pairs]

  def show
    @song = Song.find(params[:id])
  end

  # 該当する曲とメロディが似てる曲の一覧ページ
  def melody_song_pairs
    @song = Song.includes(:artists, :song_pairs).find(params[:id])
    redirect_song_page?(@song, 'melody')
    @pair_song_list = Kaminari.paginate_array(@song.pair_song_list(similarity_category: 'melody')).page(params[:page])
  end

  # 該当する曲とジャンル・スタイルが似てる曲の一覧ページ
  def style_song_pairs
    @song = Song.includes(:artists, :song_pairs).find(params[:id])
    redirect_song_page?(@song, 'style')
    @pair_song_list = Kaminari.paginate_array(@song.pair_song_list(similarity_category: 'style')).page(params[:page])
  end

  # 該当する曲のサンプリング関連曲の一覧ページ
  def sampling_song_pairs
    @song = Song.includes(:artists, :song_pairs).find(params[:id])
    redirect_song_page?(@song, 'sampling')
    @pair_song_list = Kaminari.paginate_array(@song.pair_song_list(similarity_category: 'sampling')).page(params[:page])
  end

  private

  # 該当する曲と関連する似てる曲・サンプリング曲一覧が3曲未満の場合に楽曲ページにリダイレクトする処理
  def redirect_song_page?(song, similarity_category)
    # 関連する曲が3曲未満であれば楽曲ページ内で記載しきれる為、ページを表示せず楽曲ページにリダイレクト
    redirect_to song_path unless song.pair_song_list(similarity_category: similarity_category).count > 3
  end
end
