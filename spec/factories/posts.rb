FactoryBot.define do
  factory :post do
    image {Faker::Internet.url}
    text {Faker::Lorem.sentence}
    association :user

    trait :image_present do
      image {Faker::Internet.url}
    end

    trait :text_invalid do
      text {nil}
    end
  end
end
