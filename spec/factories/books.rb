FactoryBot.define do
  factory :book do
    name { Faker::Lorem.characters(number: 5) }
    introduce { Faker::Lorem.characters(number: 20) }
    delete_key { Faker::Lorem.characters(number: 5) }
    customer
  end
end
