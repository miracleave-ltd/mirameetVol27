FactoryBot.define do
  factory :post do
    image { Faker::Internet.url }
    text { Faker::Lorem.sentence }
    association :user

    trait :text_invalid do
      text { nil }
    end
  end
end
