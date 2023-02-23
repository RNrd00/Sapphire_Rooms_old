require "rails_helper"

RSpec.describe "Tagモデルのテスト", type: :model do
  describe "バリデーションのテスト" do
    subject { tag.valid? }
  end

  describe "アソシエーションのテスト" do
    context "RatingTagモデルとの関係" do
      it "1:Nとなっている" do
        expect(Tag.reflect_on_association(:rating_tags).macro).to eq :has_many
      end
    end
    context "Ratingモデルとの関係" do
      it "1:Nとなっている" do
        expect(Tag.reflect_on_association(:ratings).macro).to eq :has_many
      end
    end
    context "BookTagモデルとの関係" do
      it "1:Nとなっている" do
        expect(Tag.reflect_on_association(:book_tags).macro).to eq :has_many
      end
    end
    context "Bookモデルとの関係" do
      it "1:Nとなっている" do
        expect(Tag.reflect_on_association(:books).macro).to eq :has_many
      end
    end
  end
end
