FactoryBot.define do
  factory :comment do
    text {Faker::Lorem.sentence}

    trait :text_invalid do
      text {nil}
    end
  end
end
