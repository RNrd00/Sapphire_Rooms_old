FactoryBot.define do
  factory :group do
    name { Faker::Lorem.characters(number: 5) }
    introduction { Faker::Lorem.characters(number: 20) }
    customer
  end
end
