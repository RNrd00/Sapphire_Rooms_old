require "rails_helper"

RSpec.describe "Bookモデルのテスト", type: :model do
  describe "バリデーションのテスト" do
    subject { book.valid? }

    let(:customer) { create(:customer) }
    let!(:book) { build(:book, customer_id: customer.id) }

    context "nameカラム" do
      it "空欄でないこと" do
        book.name = ""
        is_expected.to eq false
      end
      it "100文字以下であること: 100文字は〇" do
        book.name = Faker::Lorem.characters(number: 100)
        is_expected.to eq true
      end
      it "100文字以下であること: 101文字は×" do
        book.name = Faker::Lorem.characters(number: 101)
        is_expected.to eq false
      end
    end

    context "introduceカラム" do
      it "空欄でないこと" do
        book.introduce = ""
        is_expected.to eq false
      end
      it "10000文字以下であること: 10000文字は〇" do
        book.introduce = Faker::Lorem.characters(number: 10_000)
        is_expected.to eq true
      end
      it "10000文字以下であること: 10001文字は×" do
        book.introduce = Faker::Lorem.characters(number: 10_001)
        is_expected.to eq false
      end
    end

    context "delete_keyカラム" do
      it "空欄でないこと" do
        book.delete_key = ""
        is_expected.to eq false
      end
      it "1文字以上であること: 1文字は〇" do
        book.delete_key = Faker::Lorem.characters(number: 1)
        is_expected.to eq true
      end
      it "1文字以上であること: 0文字は×" do
        book.delete_key = Faker::Lorem.characters(number: 0)
        is_expected.to eq false
      end
      it "100文字以下であること: 100文字は〇" do
        book.delete_key = Faker::Lorem.characters(number: 100)
        is_expected.to eq true
      end
      it "100文字以下であること: 101文字は×" do
        book.delete_key = Faker::Lorem.characters(number: 101)
        is_expected.to eq false
      end
    end
  end

  describe "アソシエーションのテスト" do
    context "Customerモデルとの関係" do
      it "N:1となっている" do
        expect(Book.reflect_on_association(:customer).macro).to eq :belongs_to
      end
    end
    context "BookCommentモデルとの関係" do
      it "1:Nとなっている" do
        expect(Book.reflect_on_association(:book_comments).macro).to eq :has_many
      end
    end
    context "Favoriteモデルとの関係" do
      it "1:Nとなっている" do
        expect(Book.reflect_on_association(:favorites).macro).to eq :has_many
      end
    end
    context "ViewCountモデルとの関係" do
      it "1:Nとなっている" do
        expect(Book.reflect_on_association(:view_counts).macro).to eq :has_many
      end
    end
    context "BookTagモデルとの関係" do
      it "1:Nとなっている" do
        expect(Book.reflect_on_association(:book_tags).macro).to eq :has_many
      end
    end
    context "Tagモデルとの関係" do
      it "1:Nとなっている" do
        expect(Book.reflect_on_association(:tags).macro).to eq :has_many
      end
    end
  end
end
