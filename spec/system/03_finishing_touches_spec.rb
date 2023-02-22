require 'rails_helper'

describe '[STEP3] 仕上げのテスト' do
  let(:customer) { create(:customer) }
  let!(:other_customer) { create(:customer) }
  let!(:book) { create(:book, customer:) }
  let!(:other_book) { create(:book, customer: other_customer) }

  describe 'サクセスメッセージのテスト' do
    subject { page }

    it 'ユーザ新規登録成功時' do
      visit new_customer_registration_path
      fill_in 'customer[name]', with: Faker::Lorem.characters(number: 9)
      fill_in 'customer[email]', with: 'a' + customer.email
      fill_in 'customer[password]', with: 'password'
      fill_in 'customer[password_confirmation]', with: 'password'
      click_button '新規登録'
      is_expected.to have_content 'アカウント登録が完了しました。'
    end
    it 'ユーザログイン成功時' do
      visit new_customer_session_path
      fill_in 'customer[email]', with: customer.email
      fill_in 'customer[password]', with: customer.password
      click_button 'ログイン'
      is_expected.to have_content 'ログインしました。'
    end
    it 'ユーザログアウト成功時' do
      visit new_customer_session_path
      fill_in 'customer[email]', with: customer.email
      fill_in 'customer[password]', with: customer.password
      click_button 'ログイン'
      logout_link = find_all('a')[10].text
      logout_link = logout_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
      click_link logout_link
      is_expected.to have_content 'ログアウトしました。'
    end
    it 'ユーザのプロフィール情報更新成功時' do
      visit new_customer_session_path
      fill_in 'customer[email]', with: customer.email
      fill_in 'customer[password]', with: customer.password
      click_button 'ログイン'
      visit edit_public_customer_path(customer)
      click_button '更新'
      is_expected.to have_content 'プロフィールの更新に成功しました！'
    end
    it '投稿データの新規投稿成功時: 投稿一覧画面から行います。' do
      visit new_customer_session_path
      fill_in 'customer[email]', with: customer.email
      fill_in 'customer[password]', with: customer.password
      click_button 'ログイン'
      visit public_books_path
      fill_in 'book[name]', with: Faker::Lorem.characters(number: 5)
      fill_in 'book[introduce]', with: Faker::Lorem.characters(number: 20)
      fill_in 'book[delete_key]', with: Faker::Lorem.characters(number: 5)
      click_button 'ルーム作成'
      is_expected.to have_content 'ルーム作成に成功しました！'
    end
    it '投稿データの更新成功時' do
      visit new_customer_session_path
      fill_in 'customer[email]', with: customer.email
      fill_in 'customer[password]', with: customer.password
      click_button 'ログイン'
      visit edit_public_book_path(book)
    end
  end

  describe '処理失敗時のテスト' do
    context 'ユーザ新規登録失敗: nameを1文字にする' do
      before do
        visit new_customer_registration_path
        @name = Faker::Lorem.characters(number: 0)
        @email = 'a' + customer.email
        fill_in 'customer[name]', with: @name
        fill_in 'customer[email]', with: @email
        fill_in 'customer[password]', with: 'password'
        fill_in 'customer[password_confirmation]', with: 'password'
      end

      it '新規登録されない' do
        expect { click_button '新規登録' }.not_to change(Customer.all, :count)
      end
      it '新規登録画面を表示しており、フォームの内容が正しい' do
        click_button '新規登録'
        expect(page).to have_content 'ログイン'
        expect(page).to have_field 'customer[name]', with: @name
        expect(page).to have_field 'customer[email]', with: @email
      end
      it 'バリデーションエラーが表示される' do
        click_button '新規登録'
        expect(page).to have_content 'Nameは1文字以上で入力してください'
      end
    end

    context 'ユーザのプロフィール情報編集失敗: nameを0文字にする' do
      before do
        @customer_old_name = customer.name
        @email = Faker::Lorem.characters(number: 0)
        @name = Faker::Lorem.characters(number: 0)
        visit new_customer_session_path
        fill_in 'customer[email]', with: customer.email
        fill_in 'customer[password]', with: customer.password
        click_button 'ログイン'
        visit edit_public_customer_path(customer)
        fill_in 'customer[name]', with: @name
        click_button '更新'
      end

      it '更新されない' do
        expect(customer.reload.name).to eq @customer_old_name
      end
      it 'ユーザ編集画面を表示しており、フォームの内容が正しい' do
        expect(page).to have_field 'customer[name]', with: @name
      end
      it 'バリデーションエラーが表示される' do
        expect(page).to have_content "Nameは1文字以上で入力してください"
      end
    end

    context '投稿データの新規投稿失敗: 投稿一覧画面から行い、nameを空にする' do
      before do
        visit new_customer_session_path
        fill_in 'customer[email]', with: customer.email
        fill_in 'customer[password]', with: customer.password
        click_button 'ログイン'
        visit public_books_path
        @introduce = Faker::Lorem.characters(number: 19)
        fill_in 'book[introduce]', with: @introduce
      end

      it '投稿が保存されない' do
        expect { click_button 'ルーム作成' }.not_to change(Book.all, :count)
      end
      it '投稿一覧画面を表示している' do
        click_button 'ルーム作成'
        expect(current_path).to eq '/public/books'
        expect(page).to have_content book.introduce
        expect(page).to have_content other_book.introduce
      end
      it '新規投稿フォームの内容が正しい' do
        expect(find_field('book[name]').text).to be_blank
        expect(page).to have_field 'book[introduce]', with: @introduce
      end
      it 'バリデーションエラーが表示される' do
        click_button 'ルーム作成'
        expect(page).to have_content "エラーが発生しました"
      end
    end

    context '投稿データの更新失敗: nameを空にする' do
      before do
        visit new_customer_session_path
        fill_in 'customer[email]', with: customer.email
        fill_in 'customer[password]', with: customer.password
        click_button 'ログイン'
        visit edit_public_book_path(book)
        @book_old_name = book.name
        fill_in 'book[name]', with: ''
        click_button '編集完了'
      end

      it '投稿が更新されない' do
        expect(book.reload.name).to eq @book_old_name
      end
      it '投稿編集画面を表示しており、フォームの内容が正しい' do
        expect(current_path).to eq '/public/books/' + book.id.to_s
        expect(find_field('book[name]').text).to be_blank
        expect(page).to have_field 'book[introduce]', with: book.introduce
      end
      it 'エラーメッセージが表示される' do
        expect(page).to have_content 'のエラーが発生しました。'
      end
    end
  end

  describe 'ログインしていない場合のアクセス制限のテスト: アクセスできず、ログイン画面に遷移する' do
    subject { current_path }

    it 'ユーザ一覧画面' do
      visit public_customers_path
      is_expected.to eq '/customers/sign_in'
    end
    it 'ユーザ詳細画面' do
      visit public_customer_path(customer)
      is_expected.to eq '/customers/sign_in'
    end
    it 'ユーザ情報編集画面' do
      visit edit_public_customer_path(customer)
      is_expected.to eq '/customers/sign_in'
    end
    it '投稿一覧画面' do
      visit public_books_path
      is_expected.to eq '/customers/sign_in'
    end
    it '投稿詳細画面' do
      visit public_book_path(book)
      is_expected.to eq '/customers/sign_in'
    end
    it '投稿編集画面' do
      visit edit_public_book_path(book)
      is_expected.to eq '/customers/sign_in'
    end
    it '検索画面' do
      visit public_search_path
      is_expected.to eq '/customers/sign_in'
    end
    it 'フォロー一覧画面' do
      visit public_customer_followings_path(customer)
      is_expected.to eq '/customers/sign_in'
    end
    it 'ブックマーク画面' do
      visit public_customer_daily_posts_path(customer)
      is_expected.to eq '/customers/sign_in'
    end
    it '退会画面' do
      visit public_customer_unsubscribe_path(customer)
      is_expected.to eq '/customers/sign_in'
    end
    it 'いいねした一覧画面' do
      visit likes_public_customer_path(customer)
      is_expected.to eq '/customers/sign_in'
    end
    it 'イベントお知らせ画面' do
      visit new_public_group_event_notice_path(customer)
      is_expected.to eq '/customers/sign_in'
    end
    it 'グループ画面' do
      visit public_groups_path
      is_expected.to eq '/customers/sign_in'
    end
    it 'グループ作成画面' do
      visit new_public_group_path
      is_expected.to eq '/customers/sign_in'
    end
    it 'グループ編集画面' do
      visit edit_public_group_path(customer)
      is_expected.to eq '/customers/sign_in'
    end
    it 'グループ一覧画面' do
      visit public_group_path(customer)
      is_expected.to eq '/customers/sign_in'
    end
    it 'チャット画面' do
      visit public_chat_path(customer)
      is_expected.to eq '/customers/sign_in'
    end
    it 'レビュー画面' do
      visit public_ratings_path
      is_expected.to eq '/customers/sign_in'
    end
    it '通知画面' do
      visit public_notifications_path
      is_expected.to eq '/customers/sign_in'
    end
  end

  describe 'ゲストユーザーのテスト' do

    subject { current_path }

    before do
      visit root_path
      click_link 'ゲストログイン'
    end

    it '投稿編集画面' do
      visit edit_public_book_path(book)
      is_expected.to eq '/public/books'
    end
    it 'イベントお知らせ画面' do
      visit new_public_group_event_notice_path(customer)
      is_expected.to eq '/'
    end
    it 'グループ編集画面' do
      visit edit_public_group_path(customer)
      is_expected.to eq '/'
    end
    it 'チャット画面' do
      visit public_chat_path(customer)
      is_expected.to eq '/public/books'
    end
  end

  describe '他人の画面のテスト' do
    before do
      visit new_customer_session_path
      fill_in 'customer[email]', with: customer.email
      fill_in 'customer[password]', with: customer.password
      click_button 'ログイン'
    end

    describe '他人の投稿詳細画面のテスト' do
      before do
        visit public_book_path(other_book)
      end

      context '表示内容の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq '/public/books/' + other_book.id.to_s
        end
        it '「ルームページ」と表示される' do
          expect(page).to have_content 'ルームページ'
        end
        it '投稿のnameが表示される' do
          expect(page).to have_content other_book.name
        end
        it '投稿のintroduceが表示される' do
          expect(page).to have_content other_book.introduce
        end
        it '投稿の編集リンクが表示されない' do
          expect(page).not_to have_link '投稿を編集する'
        end
        it '投稿の削除リンクが表示されない' do
          expect(page).not_to have_link '投稿を削除する'
        end
      end
    end

      context '他人の投稿編集画面' do
       it '遷移できず、投稿一覧画面にリダイレクトされる' do
        visit edit_public_book_path(other_book)
        expect(current_path).to eq '/public/books'
       end
      end

    describe '他人のユーザ詳細画面のテスト' do
      before do
        visit public_customer_path(other_customer)
      end

      context '表示の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq '/public/customers/' + other_customer.id.to_s
        end
        it '投稿一覧のユーザ画像のリンク先が正しい' do
          expect(page).to have_link '', href: public_customer_path(other_customer)
        end
        it '投稿一覧に他人の投稿のnameが表示される' do
          expect(page).to have_content other_book.name
        end
        it '投稿一覧に他人の投稿のintroduceが表示される' do
          expect(page).to have_content other_book.introduce
        end
        it '自分の投稿は表示されない' do
          expect(page).not_to have_content book.name
          expect(page).not_to have_content book.introduce
        end
      end
    end

    context '他人のユーザ情報編集画面' do
      it '遷移できず、自分のユーザ詳細画面にリダイレクトされる' do
        visit edit_public_customer_path(other_customer)
        expect(current_path).to eq '/public/customers/' + customer.id.to_s
      end
    end
  end

  describe 'グリッドシステムのテスト: container, row, col-sm-〇を正しく使えている' do
    subject { page }

    before do
      visit new_customer_session_path
      fill_in 'customer[email]', with: customer.email
      fill_in 'customer[password]', with: customer.password
      click_button 'ログイン'
    end

    it 'ユーザ一覧画面' do
      visit public_customers_path
      is_expected.to have_selector '.container .row .col-md-12'
      is_expected.to have_selector '.container .row .col-sm-12'
    end
    it 'ユーザ詳細画面' do
      visit public_customer_path(customer)
      is_expected.to have_selector '.container .row .col-sm-12'
    end
    it '投稿一覧画面' do
      visit public_books_path
      is_expected.to have_selector '.container .row .col-sm-12'
    end
    it '投稿詳細画面' do
      visit public_book_path(book)
      is_expected.to have_selector '.container .row .col-sm-12'
    end
  end

  describe 'アイコンのテスト' do
    context 'トップ画面' do
      subject { page }

      before do
        visit root_path
      end

      it 'ホームのアイコンが表示される' do
        is_expected.to have_selector '.fas.fa-home'
      end
    end

    context 'アバウト画面' do
      subject { page }

      before do
        visit '/public/home/about'
      end

      it 'サイト紹介のアイコンが表示される' do
        is_expected.to have_selector '.fas.fa-store'
      end
    end

    context 'ヘッダー: ログインしていない場合' do
      subject { page }

      before do
        visit root_path
      end

      it 'ホームリンクのアイコンが表示される' do
        is_expected.to have_selector '.fas.fa-home'
      end
      it 'サイト紹介リンクのアイコンが表示される' do
        is_expected.to have_selector '.fas.fa-store'
      end
      it '辞典リンクのアイコンが表示される' do
        is_expected.to have_selector '.fas.fa-book'
      end
      it '会員登録リンクのアイコンが表示される' do
        is_expected.to have_selector '.fas.fa-user-plus'
      end
      it 'ログインリンクのアイコンが表示される' do
        is_expected.to have_selector '.fas.fa-sign-in-alt'
      end
      it 'ゲストログインリンクのアイコンが表示される' do
        is_expected.to have_selector '.fa.fa-user'
      end
      it '管理者ログインリンクのアイコンが表示される' do
        is_expected.to have_selector '.fas.fa-chess-king'
      end
    end

    context 'ヘッダー: ログインしている場合' do
      subject { page }

      before do
        visit new_customer_session_path
        fill_in 'customer[email]', with: customer.email
        fill_in 'customer[password]', with: customer.password
        click_button 'ログイン'
      end

      it 'ホームリンクのアイコンが表示される' do
        is_expected.to have_selector '.fas.fa-home'
      end
      it '会員一覧リンクのアイコンが表示される' do
        is_expected.to have_selector '.fas.fa-user-friends'
      end
      it 'ルームリンクのアイコンが表示される' do
        is_expected.to have_selector '.fas.fa-book-open'
      end
      it 'レビューリンクのアイコンが表示される' do
        is_expected.to have_selector '.fas.fa-star'
      end
      it '通知リンクのアイコンが表示される' do
        is_expected.to have_selector '.fas.fa-circle'
      end
      it 'グループ一覧リンクのアイコンが表示される' do
        is_expected.to have_selector '.fas.fa-users'
      end
      it 'グループ作成リンクのアイコンが表示される' do
        is_expected.to have_selector '.fas.fa-object-group'
      end
      it '退会リンクのアイコンが表示される' do
        is_expected.to have_selector '.fas.fa-users-slash'
      end
      it '辞典リンクのアイコンが表示される' do
        is_expected.to have_selector '.fas.fa-book'
      end
      it 'ログアウトリンクのアイコンが表示される' do
        is_expected.to have_selector '.fas.fa-sign-out-alt'
      end
    end
  end
end
