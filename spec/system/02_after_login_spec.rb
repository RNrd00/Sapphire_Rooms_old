require 'rails_helper'

describe '[STEP2] ユーザログイン後のテスト' do
  let(:customer) { create(:customer) }
  let!(:other_customer) { create(:customer) }
  let!(:book) { create(:book, customer:) }
  let!(:other_book) { create(:book, customer: other_customer) }
  let!(:favorite) { create(:favorite, book: book, customer: customer) }
  let!(:rating) { create(:rating, customer:) }
  let!(:other_rating) { create(:rating, customer: other_customer) }

  before do
    visit new_customer_session_path
    fill_in 'customer[email]', with: customer.email
    fill_in 'customer[password]', with: customer.password
    click_button 'ログイン'
  end

  describe 'ヘッダーのテスト: ログインしている場合' do
    context 'リンクの内容を確認: ※ログアウトは『ユーザログアウトのテスト』でテスト済みになります。' do
      subject { current_path }

      it 'ホームを押すと、自分のユーザ詳細画面に遷移する' do
        home_link = find_all('a')[1].text
        home_link = home_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link home_link
        is_expected.to eq '/public/customers/' + customer.id.to_s
      end
      it '会員一覧を押すと、ユーザ一覧画面に遷移する' do
        customers_link = find_all('a')[2].text
        customers_link = customers_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link customers_link
        is_expected.to eq '/public/customers'
      end
      it 'ルームを押すと、ルーム一覧画面に遷移する' do
        books_link = find_all('a')[3].text
        books_link = books_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link books_link
        is_expected.to eq '/public/books'
      end
      it 'レビューを押すと、レビュー画面に遷移する' do
        rate_link = find_all('a')[4].text
        rate_link = rate_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link rate_link
        is_expected.to eq '/public/ratings'
      end
      it '通知を押すと、通知画面に遷移する' do
        notification_link = find_all('a')[5].text
        notification_link = notification_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link notification_link
        is_expected.to eq '/public/notifications'
      end
      it 'グループ一覧を押すと、グループ一覧画面に遷移する' do
        group_link = find_all('a')[6].text
        group_link = group_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link group_link
        is_expected.to eq '/public/groups'
      end
      it 'グループ作成を押すと、グループ作成覧画面に遷移する' do
        creategroup_link = find_all('a')[7].text
        creategroup_link = creategroup_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link creategroup_link
        is_expected.to eq '/public/groups/new'
      end
      it '退会するを押すと、退会画面に遷移する' do
        unsubscribe_link = find_all('a')[8].text
        unsubscribe_link = unsubscribe_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link unsubscribe_link
        is_expected.to eq '/public/customers/' + customer.id.to_s + '/unsubscribe'
      end
      it '辞典を押すと、辞典画面に遷移する' do
        dictionaries_link = find_all('a')[9].text
        dictionaries_link = dictionaries_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link dictionaries_link
        is_expected.to eq '/public/dictionaries'
      end
    end
  end

  describe '投稿一覧画面のテスト' do
    before do
      visit public_books_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/public/books'
      end
      it '自分と他人の画像のリンク先が正しい' do
        expect(page).to have_link '', href: public_customer_path(book.customer)
        expect(page).to have_link '', href: public_customer_path(other_book.customer)
      end
      it '自分の投稿と他人の投稿のタイトルのリンク先がそれぞれ正しい' do
        expect(page).to have_link '入室する', href: public_book_path(book.id)
        expect(page).to have_link '入室する', href: public_book_path(other_book.id)
      end
      it '自分の投稿と他人の投稿のオピニオンが表示される' do
        expect(page).to have_content book.introduce
        expect(page).to have_content other_book.introduce
      end
    end

    context 'ルーム作成成功のテスト' do
      before do
        fill_in 'book[name]', with: Faker::Lorem.characters(number: 5)
        fill_in 'book[introduce]', with: Faker::Lorem.characters(number: 20)
        fill_in 'book[delete_key]', with: Faker::Lorem.characters(number: 5)
      end
      it '自分の新しいルームが正しく保存される' do
        expect { click_button 'ルーム作成' }.to change(customer.books, :count).by(1)
      end
      it 'リダイレクト先が、保存できたルームの詳細画面になっている' do
        click_button 'ルーム作成'
        expect(current_path).to eq '/public/books/' + Book.last.id.to_s
      end
    end

   context 'いいね確認' do
    it 'リンクが諸々正しい' do
      expect(page).to have_link '', href: public_book_favorites_path(book)
      expect(page).to have_css('i.fas')
    end
   end
  end

  describe '自分の投稿詳細画面のテスト' do
    before do
      visit public_book_path(book)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/public/books/' + book.id.to_s
      end
      it '「ルームページ」と表示される' do
        expect(page).to have_content 'ルームページ'
      end
      it '投稿のnameが表示される' do
        expect(page).to have_content book.name
      end
      it '投稿のintroduceが表示される' do
        expect(page).to have_content book.introduce
      end
      it '投稿の編集リンクが表示される' do
        expect(page).to have_link 'ルームを編集する', href: edit_public_book_path(book)
      end
    end

    context '編集リンクのテスト' do
      it '編集画面に遷移する' do
        click_link 'ルームを編集する'
        expect(current_path).to eq '/public/books/' + book.id.to_s + '/edit'
      end
    end

   context 'いいね確認' do
    it 'リンクが諸々正しい' do
      expect(page).to have_link '', href: public_book_favorites_path(book)
      expect(page).to have_css('i.fas')
    end
   end
  end

  describe '自分の投稿編集画面のテスト' do
    before do
      visit edit_public_book_path(book)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/public/books/' + book.id.to_s + '/edit'
      end
      it '「ルーム編集画面」と表示される' do
        expect(page).to have_content 'ルーム編集画面'
      end
      it 'name編集フォームが表示される' do
        expect(page).to have_field 'book[name]', with: book.name
      end
      it 'introduce編集フォームが表示される' do
        expect(page).to have_field 'book[introduce]', with: book.introduce
      end
      it '編集完了ボタンが表示される' do
        expect(page).to have_button '編集完了'
      end
      it '詳細ページに戻るリンクが表示される' do
        expect(page).to have_link '詳細ページに戻る', href: public_book_path(book)
      end
      it '一覧画面に戻るリンクが表示される' do
        expect(page).to have_link '一覧画面に戻る', href: public_books_path
      end
    end

    context '編集成功のテスト' do
      before do
        @book_old_name = book.name
        @book_old_introduce = book.introduce
        @book_old_delete_key = book.delete_key
        fill_in 'book[name]', with: Faker::Lorem.characters(number: 4)
        fill_in 'book[introduce]', with: Faker::Lorem.characters(number: 19)
        fill_in 'book[delete_key]', with: Faker::Lorem.characters(number: 5)
        click_button '編集完了'
      end

      it 'nameが正しく更新される' do
        expect(book.reload.name).not_to eq @book_old_name
      end
      it 'introduceが正しく更新される' do
        expect(book.reload.introduce).not_to eq @book_old_introduce
      end
      it 'delete_keyが正しく更新される' do
        expect(book.reload.introduce).not_to eq @book_old_delete_key
      end
      it 'リダイレクト先が、更新した投稿の詳細画面になっている' do
        expect(current_path).to eq '/public/books/' + book.id.to_s
        expect(page).to have_content 'ルームページ'
      end
    end
  end

  describe 'ユーザ一覧画面のテスト' do
    before do
      visit public_customers_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/public/customers'
      end
      it '自分と他人の画像が表示される: fallbackの画像が1つ＋一覧(1人)の1つの計2つ存在する' do
        expect(all('img').size).to eq(2)
      end
      it '自分と他人の名前がそれぞれ表示される' do
        expect(page).to have_content customer.name
        expect(page).to have_content other_customer.name
      end
      it '自分と他人のshowリンクがそれぞれ表示される' do
        expect(page).to have_link '詳細画面', href: public_customer_path(customer)
        expect(page).to have_link '詳細画面', href: public_customer_path(other_customer)
      end
    end
  end

  describe '自分のユーザ詳細画面のテスト' do
    before do
      visit public_customer_path(customer)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/public/customers/' + customer.id.to_s
      end
      it '投稿一覧に自分の投稿のintroduceが表示される' do
        expect(page).to have_content book.introduce
      end
      it '他人の投稿は表示されない' do
        expect(page).not_to have_link '', href: public_customer_path(other_customer)
        expect(page).not_to have_content other_book.name
        expect(page).not_to have_content other_book.introduce
      end
    end
  end

  describe '自分のユーザ情報編集画面のテスト' do
    before do
      visit edit_public_customer_path(customer)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/public/customers/' + customer.id.to_s + '/edit'
      end
      it '名前編集フォームに自分の名前が表示される' do
        expect(page).to have_field 'customer[name]', with: customer.name
      end
      it '画像編集フォームが表示される' do
        expect(page).to have_field 'customer[profile_image]'
      end
      it '自己紹介編集フォームに自分の自己紹介文が表示される' do
        expect(page).to have_field 'customer[introduce]', with: customer.introduce
      end
      it '更新ボタンが表示される' do
        expect(page).to have_button '更新'
      end
    end

    context '更新成功のテスト' do
      before do
        @customer_old_name = customer.name
        @customer_old_introduce = customer.introduce
        fill_in 'customer[name]', with: Faker::Lorem.characters(number: 9)
        fill_in 'customer[introduce]', with: Faker::Lorem.characters(number: 19)
        expect(customer.profile_image).to be_attached
        click_button '更新'
        save_page
      end

      it 'nameが正しく更新される' do
        expect(customer.reload.name).not_to eq @customer_old_name
      end
      it 'introductionが正しく更新される' do
        expect(customer.reload.introduce).not_to eq @customer_old_intrpduction
      end
      it 'リダイレクト先が、自分のユーザ詳細画面になっている' do
        expect(current_path).to eq '/public/customers/' + customer.id.to_s
      end
    end
  end

  describe 'フォロー一覧画面のテスト' do
  before do
    visit public_customer_followings_path(customer)
  end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/public/customers/' + customer.id.to_s + '/followings'
      end
    end
  end

  describe 'フォロワーー一覧画面のテスト' do
  before do
    visit public_customer_followers_path(customer)
  end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/public/customers/' + customer.id.to_s + '/followers'
      end
    end
  end

  describe 'ブックマーク画面のテスト' do
  before do
    visit likes_public_customer_path(customer)
  end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/public/customers/' + customer.id.to_s + '/likes'
      end
    end
  end

  describe 'グループ一覧画面のテスト' do
  before do
    visit public_groups_path
  end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/public/groups'
      end
    end
  end

  describe 'グループ作成画面のテスト' do
  before do
    visit new_public_group_path
  end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/public/groups/new'
      end
      it 'グループ作成ボタンが表示される' do
        expect(page).to have_button 'グループ作成'
      end
    end
  end

  describe '通知画面のテスト' do
  before do
    visit public_notifications_path
  end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/public/notifications'
      end
    end
  end

    describe 'レビュー一覧画面のテスト' do
    before do
      visit public_ratings_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/public/ratings'
      end
      it '自分の投稿と他人の投稿のオピニオンが表示される' do
        expect(page).to have_content rating.introduction
        expect(page).to have_content other_rating.introduction
      end
    end

    context 'レビュー作成成功のテスト' do
      before do
        fill_in 'rating[name]', with: Faker::Lorem.characters(number: 5)
        fill_in 'rating[introduction]', with: Faker::Lorem.characters(number: 20)
      end
      it '自分の新しいレビューが正しく保存される' do
        expect { click_button 'レビューする' }.to change(customer.ratings, :count).by(1)
      end
      it 'リダイレクト先が、レビュー一覧画面になっている' do
        click_button 'レビューする'
        expect(current_path).to eq '/public/ratings'
      end
    end
  end
end
