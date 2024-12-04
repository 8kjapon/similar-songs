module SongPairsHelper
  # 時間指定部分(12:34のような形式)を自動でウィジェットの再生時間移動リンクに変換するヘルパー
  # `views/song_pairs/_song_info.html.erb`内で使用
  def parse_time_links(description, media_widget_id)
    # 時間指定部分を正規表現で検知し、そこを基準に説明テキストの分割
    # 変換が必要な部分は変換し`description_parts`に格納
    description_parts = description.split(/(\d{1,2}:\d{2})/).map do |segment|
      # 分割されたテキストのうち、時間指定部分であれば再生時間移動リンクに変換、そうでなければそのまま返す
      if segment.match?(/\A\d{1,2}:\d{2}\z/)
        seconds = time_to_seconds(segment) # 時間指定部分を秒数に変換
        link_to(segment, "javascript:void(0);", class: "time-link", data: { action: "media#seek", media_widget_id: media_widget_id, time: seconds })
      else
        segment
      end
    end
    # 処理の済んだ文字列を統合して出力
    safe_join(description_parts)
  end

  private

  # 時間指定部分(12:34のような形式)から秒数値を取得する処理
  def time_to_seconds(time_str)
    minutes, seconds = time_str.split(":").map(&:to_i) # `12:34`の形式を秒数計算出来るように分割
    (minutes * 60) + seconds # 出力する秒数(計算結果)
  end
end
