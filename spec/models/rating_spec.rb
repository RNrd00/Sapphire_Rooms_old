require "rails_helper"

RSpec.describe "Ratingモデルのテスト", type: :model do
  describe "バリデーションのテスト" do
    subject { rating.valid? }

    let(:customer) { create(:customer) }
    let!(:rating) { build(:rating, customer_id: customer.id) }

    context "nameカラム" do
      it "空欄ではないこと" do
        rating.name = ""
        is_expected.to eq false
      end
      it "100文字以下であること。100文字は○" do
        rating.name = Faker::Lorem.characters(number: 100)
        is_expected.to eq true
      end
      it "100文字以下であること。101文字は✗" do
        rating.name = Faker::Lorem.characters(number: 101)
        is_expected.to eq false
      end
    end

    context "introductionカラム" do
      it "空欄でないこと" do
        rating.introduction = ""
        is_expected.to eq false
      end
      it "10000文字以下であること: 10000文字は〇" do
        rating.introduction = Faker::Lorem.characters(number: 10_000)
        is_expected.to eq true
      end
      it "10000文字以下であること: 10001文字は×" do
        rating.introduction = Faker::Lorem.characters(number: 10_001)
        is_expected.to eq false
      end
    end
  end

  describe "アソシエーションのテスト" do
    context "Customerモデルとの関係" do
      it "N:1となっている" do
        expect(Rating.reflect_on_association(:customer).macro).to eq :belongs_to
      end
    end
    context "RatingTagモデルとの関係" do
      it "1:Nとなっている" do
        expect(Rating.reflect_on_association(:rating_tags).macro).to eq :has_many
      end
    end
    context "Tagモデルとの関係" do
  it "1:Nとなっている" do
    expect(Rating.reflect_on_association(:tags).macro).to eq :has_many
  end
end
  end
end
