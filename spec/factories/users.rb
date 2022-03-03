FactoryBot.define do
  factory :user do
    nickname { Faker::Lorem.unique.characters(number:10) }
    email { Faker::Internet.free_email(name: nickname) }
    password { Faker::Internet.password(min_length: 6) }
    password_confirmation { password }

    trait :invalid do
      email { nil }
    end
  end
end
