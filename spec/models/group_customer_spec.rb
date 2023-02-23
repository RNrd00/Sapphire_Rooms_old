require "rails_helper"

RSpec.describe "GroupCustomerモデルのテスト", type: :model do
  describe "バリデーションのテスト" do
    subject { group_customer.valid? }

    context "Groupモデルとの関係" do
      it "N:1となっている" do
        expect(GroupCustomer.reflect_on_association(:group).macro).to eq :belongs_to
      end
    end
    context "Customerモデルとの関係" do
      it "N:1となっている" do
        expect(GroupCustomer.reflect_on_association(:customer).macro).to eq :belongs_to
      end
    end
  end
end
