require 'rails_helper'

RSpec.describe 'Bookモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { book.valid? }

    let(:customer) { create(:customer) }
    let!(:book) { build(:book, customer_id: customer.id) }

    context 'nameカラム' do
      it '空欄でないこと' do
        book.name = ''
        is_expected.to eq false
      end
    end

    context 'introduceカラム' do
      it '空欄でないこと' do
        book.introduce = ''
        is_expected.to eq false
      end
      it '10000文字以下であること: 10000文字は〇' do
        book.introduce = Faker::Lorem.characters(number: 10000)
        is_expected.to eq true
      end
      it '10000文字以下であること: 10001文字は×' do
        book.introduce = Faker::Lorem.characters(number: 10001)
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Customerモデルとの関係' do
      it 'N:1となっている' do
        expect(Book.reflect_on_association(:customer).macro).to eq :belongs_to
      end
    end
  end
end
