FactoryBot.define do
  factory :contact do
    association :user
    message { Faker::Lorem.paragraph }
    status { :pending }
  end
end
