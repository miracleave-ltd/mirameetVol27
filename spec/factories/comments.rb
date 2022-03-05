FactoryBot.define do
  factory :comment do
    text { Faker::Lorem.sentence }
    association :post
    user { post.user }

    trait :text_invalid do
      text { nil }
    end
  end
end
