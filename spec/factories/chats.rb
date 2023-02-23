FactoryBot.define do
  factory :chat do
    message { Faker::Lorem.characters(number: 5) }
    customer
  end
end
