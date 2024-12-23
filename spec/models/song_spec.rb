require 'rails_helper'

RSpec.describe Song, type: :model do
  it '曲名、メディアURLが必須項目になっているか' do
    song = build(:song)
    song.title = nil
    song.media_url = nil
    song.valid?
    expect(song.errors[:title]).to include('曲名が入力されていません')
    expect(song.errors[:media_url]).to include('メディアURLが入力されていないか、形式が正しくありません')
  end

  it 'メディアURLの形式に制限があるか' do
    song = build(:song)
    song.media_url = "https://www.nicovideo.jp/watch/sm01234567"
    song.valid?
    expect(song.errors[:media_url]).to include('メディアURLが入力されていないか、形式が正しくありません')
  end

  it 'リリース日が未来の数値でないか' do
    song = build(:song)
    song.release_date = '9999'
    song.valid?
    expect(song.errors[:release_date]).to include('は未来の数値にできません')
  end
end
