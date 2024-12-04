module SongPairsHelper
  def parse_time_links(description, media_widget_id)
    description.gsub(/(\d{1,2}:\d{2})/) do |time|
      seconds = time_to_seconds(time)
      link_to time, "javascript:void(0);", class: "time-link", data: { action: "media#seek", media_widget_id: media_widget_id, time: seconds }
    end.html_safe
  end

  private

  def time_to_seconds(time_str)
    minutes, seconds = time_str.split(":").map(&:to_i)
    minutes * 60 + seconds
  end
end