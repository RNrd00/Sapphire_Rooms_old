require "rails_helper"

RSpec.describe "CustomerRoomモデルのテスト", type: :model do
  describe "バリデーションのテスト" do
    subject { customer_room.valid? }

    context "Customerモデルとの関係" do
      it "N:1となっている" do
        expect(CustomerRoom.reflect_on_association(:customer).macro).to eq :belongs_to
      end
    end
    context "Roomモデルとの関係" do
      it "N:1となっている" do
        expect(CustomerRoom.reflect_on_association(:room).macro).to eq :belongs_to
      end
    end
  end
end
