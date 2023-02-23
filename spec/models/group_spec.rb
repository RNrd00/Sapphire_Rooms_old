require "rails_helper"

RSpec.describe "Groupモデルのテスト", type: :model do
  describe "バリデーションのテスト" do
    subject { group.valid? }
  end

  describe "アソシエーションのテスト" do
    context "Ownerモデルとの関係" do
      it "N:1となっている" do
        expect(Group.reflect_on_association(:owner).macro).to eq :belongs_to
      end
    end
    context "GroupCustomerモデルとの関係" do
      it "1:Nとなっている" do
        expect(Group.reflect_on_association(:group_customers).macro).to eq :has_many
      end
    end
    context "Customerモデルとの関係" do
      it "1:Nとなっている" do
        expect(Group.reflect_on_association(:customers).macro).to eq :has_many
      end
    end
  end
end
