FactoryBot.define do
  factory :book_comment do
    comment { Faker::Lorem.characters(number: 5) }
    customer
  end
end
