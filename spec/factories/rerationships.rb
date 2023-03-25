FactoryBot.define do
  factory :relationship do
    follower_id { FactoryBot.create(:customer).id }
    followed_id { FactoryBot.create(:customer).id }
  end
end
