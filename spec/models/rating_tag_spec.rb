require "rails_helper"

RSpec.describe "RatingTagモデルのテスト", type: :model do
  describe "バリデーションのテスト" do
    subject { rating_tag.valid? }

    context "Ratingモデルとの関係" do
      it "N:1となっている" do
        expect(RatingTag.reflect_on_association(:rating).macro).to eq :belongs_to
      end
    end
    context "Tagモデルとの関係" do
      it "N:1となっている" do
        expect(RatingTag.reflect_on_association(:tag).macro).to eq :belongs_to
      end
    end
  end
end
