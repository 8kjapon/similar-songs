require 'rails_helper'

RSpec.describe SongArtist, type: :model do
  it '同じ曲とアーティストの組み合わせが作れないか' do
    song_artist1 = create(:song_artist)
    song_artist2 = build(:song_artist)
    song_artist2.song_id = song_artist1.song_id
    song_artist2.artist_id = song_artist1.artist_id
    song_artist2.valid?
    expect(song_artist2.errors[:song_id]).to include('既に存在している組み合わせです')
  end
end
