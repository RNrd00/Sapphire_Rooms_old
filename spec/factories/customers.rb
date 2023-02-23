FactoryBot.define do
  factory :customer do
    name { Faker::Lorem.characters(number: 10) }
    email { Faker::Internet.email }
    introduce { Faker::Lorem.characters(number: 20) }
    password { "password" }
    password_confirmation { "password" }

    after(:build) do |customer|
      customer.profile_image.attach(io: File.open("spec/images/profile_image.jpeg"), filename: "profile_image.jpeg",
                                    content_type: "application/xlsx")
    end
  end
end
