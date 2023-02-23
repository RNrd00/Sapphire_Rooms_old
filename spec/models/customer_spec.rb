require "rails_helper"

RSpec.describe "Customerモデルのテスト", type: :model do
  describe "バリデーションのテスト" do
    subject { customer.valid? }

    let!(:other_customer) { create(:customer) }
    let(:customer) { build(:customer) }

    context "nameカラム" do
      it "空欄でないこと" do
        customer.name = ""
        is_expected.to eq false
      end
      it "1文字以上であること: 0文字は×" do
        customer.name = Faker::Lorem.characters(number: 0)
        is_expected.to eq false
      end
      it "1文字以上であること: 1文字は〇" do
        customer.name = Faker::Lorem.characters(number: 1)
        is_expected.to eq true
      end
      it "100文字以下であること: 100文字は〇" do
        customer.name = Faker::Lorem.characters(number: 100)
        is_expected.to eq true
      end
      it "101文字以下であること: 101文字は×" do
        customer.name = Faker::Lorem.characters(number: 101)
        is_expected.to eq false
      end
      it "一意性があること" do
        customer.name = other_customer.name
        is_expected.to eq false
      end
    end

    context "introduceカラム" do
      it "10000文字以下であること: 10000文字は〇" do
        customer.introduce = Faker::Lorem.characters(number: 10_000)
        is_expected.to eq true
      end
      it "10000文字以下であること: 100001文字は×" do
        customer.introduce = Faker::Lorem.characters(number: 10_001)
        is_expected.to eq false
      end
    end
  end

  describe "アソシエーションのテスト" do
    context "Bookモデルとの関係" do
      it "1:Nとなっている" do
        expect(Customer.reflect_on_association(:books).macro).to eq :has_many
      end
    end
    context "BookCommentモデルとの関係" do
      it "1:Nとなっている" do
        expect(Customer.reflect_on_association(:book_comments).macro).to eq :has_many
      end
    end
    context "Ratingモデルとの関係" do
      it "1:Nとなっている" do
        expect(Customer.reflect_on_association(:ratings).macro).to eq :has_many
      end
    end
    context "Favoriteモデルとの関係" do
      it "1:Nとなっている" do
        expect(Customer.reflect_on_association(:favorites).macro).to eq :has_many
      end
    end
    context "GroupCustomerモデルとの関係" do
      it "1:Nとなっている" do
        expect(Customer.reflect_on_association(:group_customers).macro).to eq :has_many
      end
    end
    context "CustomerRoomモデルとの関係" do
      it "1:Nとなっている" do
        expect(Customer.reflect_on_association(:customer_rooms).macro).to eq :has_many
      end
    end
    context "Chatモデルとの関係" do
      it "1:Nとなっている" do
        expect(Customer.reflect_on_association(:chats).macro).to eq :has_many
      end
    end
    context "Roomモデルとの関係" do
      it "1:Nとなっている" do
        expect(Customer.reflect_on_association(:rooms).macro).to eq :has_many
      end
    end
    context "ViewCountモデルとの関係" do
      it "1:Nとなっている" do
        expect(Customer.reflect_on_association(:view_counts).macro).to eq :has_many
      end
    end
    context "ReverseOfRelationshipモデルとの関係" do
      it "1:Nとなっている" do
        expect(Customer.reflect_on_association(:reverse_of_relationships).macro).to eq :has_many
      end
    end
    context "Followerモデルとの関係" do
      it "1:Nとなっている" do
        expect(Customer.reflect_on_association(:followers).macro).to eq :has_many
      end
    end
    context "Relationshipモデルとの関係" do
      it "1:Nとなっている" do
        expect(Customer.reflect_on_association(:relationships).macro).to eq :has_many
      end
    end
    context "Followingモデルとの関係" do
      it "1:Nとなっている" do
        expect(Customer.reflect_on_association(:followings).macro).to eq :has_many
      end
    end
    context "ActiveNotificationモデルとの関係" do
      it "1:Nとなっている" do
        expect(Customer.reflect_on_association(:active_notifications).macro).to eq :has_many
      end
    end
    context "PassiveNotificationモデルとの関係" do
      it "1:Nとなっている" do
        expect(Customer.reflect_on_association(:passive_notifications).macro).to eq :has_many
      end
    end
  end
end
