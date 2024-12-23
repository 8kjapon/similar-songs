FactoryBot.define do
  factory :song_artist do
    association :song
    association :artist
  end
end
