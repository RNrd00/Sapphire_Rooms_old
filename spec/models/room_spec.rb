require "rails_helper"

RSpec.describe "Roomモデルのテスト", type: :model do
  describe "バリデーションのテスト" do
    subject { room.valid? }

    context "CustomerRoomモデルとの関係" do
      it "1:Nとなっている" do
        expect(Room.reflect_on_association(:customer_rooms).macro).to eq :has_many
      end
    end
    context "Chatモデルとの関係" do
      it "1:Nとなっている" do
        expect(Room.reflect_on_association(:chats).macro).to eq :has_many
      end
    end
  end
end
