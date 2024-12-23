require 'rails_helper'

RSpec.describe SongPair, type: :model do
  it '楽曲説明部分が必須項目になっているか' do
    song_pair = build(:song_pair)
    song_pair.original_song_description = nil
    song_pair.similar_song_description = nil
    song_pair.valid?
    expect(song_pair.errors[:original_song_description]).to include('曲1の説明が入力されていません')
    expect(song_pair.errors[:similar_song_description]).to include('曲2の説明が入力されていません')
  end

  it '同じ曲の組み合わせが作れないか' do
    song_pair = build(:song_pair)
    song_pair.original_song_id = song_pair.similar_song_id
    song_pair.valid?
    expect(song_pair.errors[:similar_song_id]).to include('同じ曲での組み合わせは作成できません')
  end
end
