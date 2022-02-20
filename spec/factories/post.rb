FactoryBot.define do
  factory :post do
    text {Faker::Lorem.sentence}
  end
end
