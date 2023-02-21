require 'rails_helper'

RSpec.describe 'Favoriteモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { favorite.valid? }

    context 'Customerモデルとの関係' do
      it 'N:1となっている' do
        expect(Favorite.reflect_on_association(:customer).macro).to eq :belongs_to
      end
    end
    context 'Bookモデルとの関係' do
      it 'N:1となっている' do
        expect(Favorite.reflect_on_association(:book).macro).to eq :belongs_to
      end
    end
  end
end
