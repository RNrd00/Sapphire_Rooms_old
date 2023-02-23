require "rails_helper"

RSpec.describe "Favoriteモデルのテスト", type: :model do
  describe "バリデーションのテスト" do
  subject { favorite.valid? }

  let!(:other_favorite) { create(:favorite) }
  let(:favorite) { build(:favorite) }

  context "1ユーザー1ルーム1いいね" do
  it "あるユーザーが同じルームにいいね出来ないこと" do
  favorite.customer = other_favorite.customer
  favorite.book = other_favorite.book
  is_expected.to eq false
end
end
end
  context "Customerモデルとの関係" do
     it "N:1となっている" do
       expect(Favorite.reflect_on_association(:customer).macro).to eq :belongs_to
     end
   end
  context "Bookモデルとの関係" do
    it "N:1となっている" do
      expect(Favorite.reflect_on_association(:book).macro).to eq :belongs_to
    end
  end
end
