FactoryBot.define do
  factory :post do
    text {Faker::Lorem.sentence}

    trait :image_present do
      image {Faker::Internet.url}
    end

    trait :text_invalid do
      text {nil}
    end
  end
end
