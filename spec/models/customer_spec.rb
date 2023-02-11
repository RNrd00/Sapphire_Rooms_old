require 'rails_helper'

RSpec.describe 'Customerモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { customer.valid? }

    let!(:other_customer) { create(:customer) }
    let(:customer) { build(:customer) }

    context 'nameカラム' do
      it '空欄でないこと' do
        customer.name = ''
        is_expected.to eq false
      end
      it '1文字以上であること: 0文字は×' do
        customer.name = Faker::Lorem.characters(number: 0)
        is_expected.to eq false
      end
      it '1文字以上であること: 1文字は〇' do
        customer.name = Faker::Lorem.characters(number: 1)
        is_expected.to eq true
      end
      it '100文字以下であること: 100文字は〇' do
        customer.name = Faker::Lorem.characters(number: 100)
        is_expected.to eq true
      end
      it '101文字以下であること: 101文字は×' do
        customer.name = Faker::Lorem.characters(number: 101)
        is_expected.to eq false
      end
      it '一意性があること' do
        customer.name = other_customer.name
        is_expected.to eq false
      end
    end

    context 'introductionカラム' do
      it '10000文字以下であること: 10000文字は〇' do
        customer.introduction = Faker::Lorem.characters(number: 10000)
        is_expected.to eq true
      end
      it '10000文字以下であること: 100001文字は×' do
        customer.introduction = Faker::Lorem.characters(number: 10001)
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Bookモデルとの関係' do
      it '1:Nとなっている' do
        expect(Customer.reflect_on_association(:books).macro).to eq :has_many
      end
    end
  end
end
