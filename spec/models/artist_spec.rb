require 'rails_helper'

RSpec.describe Artist, type: :model do
  it 'アーティスト名が必須項目になっているか' do
    artist = build(:artist)
    artist.name = nil
    artist.valid?
    expect(artist.errors[:name]).to include('アーティスト名が入力されていません')
  end

  it 'アーティスト名が255文字以下制限であるか' do
    artist = build(:artist)
    artist.name = 'a' * 256
    artist.valid?
    expect(artist.errors[:name]).to include('アーティスト名は255文字以内で入力してください')
  end
end
