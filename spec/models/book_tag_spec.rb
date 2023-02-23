require "rails_helper"

RSpec.describe "BookTagモデルのテスト", type: :model do
  describe "バリデーションのテスト" do
    subject { book_tag.valid? }

    context "Bookモデルとの関係" do
      it "N:1となっている" do
        expect(BookTag.reflect_on_association(:book).macro).to eq :belongs_to
      end
    end
    context "Tagモデルとの関係" do
      it "N:1となっている" do
        expect(BookTag.reflect_on_association(:tag).macro).to eq :belongs_to
      end
    end
  end
end
