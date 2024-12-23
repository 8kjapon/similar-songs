FactoryBot.define do
  factory :song_pair do
    association :original_song, factory: :song
    association :similar_song, factory: :song
    original_song_description { Faker::Lorem.sentence }
    similar_song_description { Faker::Lorem.sentence }
    similarity_category_id { create(:similarity_category).id }
    user_id { create(:user).id }
  end
end
