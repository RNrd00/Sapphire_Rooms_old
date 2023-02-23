require "rails_helper"

RSpec.describe "Notificationモデルのテスト", type: :model do
  describe "バリデーションのテスト" do
    subject { notification.valid? }

    context "Relationshipモデルとの関係" do
      it "N:1となっている" do
        expect(Notification.reflect_on_association(:relationship).macro).to eq :belongs_to
      end
    end
    context "Chatモデルとの関係" do
      it "N:1となっている" do
        expect(Notification.reflect_on_association(:chat).macro).to eq :belongs_to
      end
    end
    context "Visitorモデルとの関係" do
      it "N:1となっている" do
        expect(Notification.reflect_on_association(:visitor).macro).to eq :belongs_to
      end
    end
    context "Visitedモデルとの関係" do
      it "N:1となっている" do
        expect(Notification.reflect_on_association(:visited).macro).to eq :belongs_to
      end
    end
  end
end
