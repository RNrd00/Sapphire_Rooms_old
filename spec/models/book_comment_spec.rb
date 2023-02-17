require 'rails_helper'

RSpec.describe 'BookCommentモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { book_comment.valid? }

    let(:customer) { create(:customer) }
    let!(:book_comment) { build(:book_comment, customer_id: customer.id) }

    context 'commentカラム' do
      it '空欄ではないこと' do
        book_comment.comment = ''
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Customerモデルとの関係' do
      it 'N:1となっている' do
        expect(BookComment.reflect_on_association(:customer).macro).to eq :belongs_to
      end
    end
    context 'Bookモデルとの関係' do
      it 'N:1となっている' do
        expect(BookComment.reflect_on_association(:book).macro).to eq :belongs_to
      end
    end
  end
end
