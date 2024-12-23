FactoryBot.define do
  factory :song do
    title { Faker::Music.album }
    release_date { Faker::Number.between(from: 1900, to: Time.zone.today.year) }
    media_url { 'https://www.youtube.com/watch?v=aiuFBFPC7YQ' }
  end
end
