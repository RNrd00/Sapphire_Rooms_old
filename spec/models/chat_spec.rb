require "rails_helper"

RSpec.describe "Chatモデルのテスト", type: :model do
  describe "バリデーションのテスト" do
    subject { chat.valid? }

    let(:customer) { create(:customer) }
    let!(:chat) { build(:chat, customer_id: customer.id) }

    context "nameカラム" do
      it "空欄ではないこと" do
        chat.message = ""
        is_expected.to eq false
      end
      it "1000文字以下であること。1001文字は✗" do
        chat.message = Faker::Lorem.characters(number: 1001)
        is_expected.to eq false
      end
    end
  end

  describe "アソシエーションのテスト" do
    context "Customerモデルとの関係" do
      it "N:1となっている" do
        expect(Chat.reflect_on_association(:customer).macro).to eq :belongs_to
      end
    end
    context "Roomモデルとの関係" do
      it "N:1となっている" do
        expect(Chat.reflect_on_association(:room).macro).to eq :belongs_to
      end
    end
    context "Notificationモデルとの関係" do
  it "1:Nとなっている" do
    expect(Chat.reflect_on_association(:notifications).macro).to eq :has_many
  end
end
  end
end
