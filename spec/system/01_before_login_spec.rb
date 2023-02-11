require 'rails_helper'

describe '[STEP1] ユーザログイン前のテスト' do
  describe 'トップ画面のテスト' do
    before do
      visit root_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/'
      end
      it '最初のページに「自分が話したい話題について話し合うルームを自由に作成することが出来ます。」と表示される？' do
        expect(page).to have_content '自分が話したい話題について話し合うルームを自由に作成することが出来ます。'
      end
    end
  end

  describe 'アバウト画面のテスト' do
    before do
      visit '/public/home/about'
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/public/home/about'
      end
    end
  end

  describe 'ヘッダーのテスト: ログインしていない場合' do
    before do
      visit root_path
    end

    context '表示内容の確認' do
      it 'SapphireRoomsリンクが表示される: 左上から1番目のリンクが「SapphireRooms」である' do
        root_link = find_all('a')[0].text
        expect(root_link).to match(/SapphireRooms/)
      end
      it 'ホームリンクが表示される: 左上から2番目のリンクが「ホーム」である' do
        root_link = find_all('a')[1].text
        expect(root_link).to match(/ホーム/)
      end
      it 'サイト紹介リンクが表示される: 左上から3番目のリンクが「サイト紹介」である' do
        about_link = find_all('a')[2].text
        expect(about_link).to match(/サイト紹介/)
      end
      it '会員登録リンクが表示される: 左上から4番目のリンクが「会員登録」である' do
        signup_link = find_all('a')[3].text
        expect(signup_link).to match(/会員登録/)
      end
      it 'ログインリンクが表示される: 左上から5番目のリンクが「ログイン」である' do
        login_link = find_all('a')[4].text
        expect(login_link).to match(/ログイン/)
      end
      it 'ゲストログインリンクが表示される: 左上から6番目のリンクが「ゲストログイン」である' do
        guestlogin_link = find_all('a')[5].text
        expect(guestlogin_link).to match(/ゲストログイン/)
      end
      it '管理者ログインリンクが表示される: 左上から7番目のリンクが「管理者ログイン」である' do
        admin_link = find_all('a')[6].text
        expect(admin_link).to match(/管理者ログイン/)
      end
    end

    context 'リンクの内容を確認' do
      subject { current_path }
      
      it 'Bookersを押すと、トップ画面に遷移する' do
        root_link = find_all('a')[0].text
        root_link = root_link.delete(' ')
        root_link.gsub!(/\n/, '')
        click_link root_link
        is_expected.to eq '/'
      end
      it 'Homeを押すと、トップ画面に遷移する' do
        root_link = find_all('a')[1].text
        root_link = root_link.delete(' ')
        root_link.gsub!(/\n/, '')
        click_link root_link
        is_expected.to eq '/'
      end
      it 'Aboutを押すと、アバウト画面に遷移する' do
        about_link = find_all('a')[2].text
        about_link = about_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link about_link
        is_expected.to eq '/public/home/about'
      end
      it 'Sign upを押すと、新規登録画面に遷移する' do
        signup_link = find_all('a')[3].text
        signup_link = signup_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link signup_link, match: :first
        is_expected.to eq '/users/sign_up'
      end
      it 'Log inを押すと、ログイン画面に遷移する' do
        login_link = find_all('a')[4].text
        login_link = login_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link login_link, match: :first
        is_expected.to eq '/customers/sign_in'
      end
    end
  end

  describe 'ユーザ新規登録のテスト' do
    before do
      visit new_customer_registration_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/customers/sign_up'
      end
      it '「会員登録」と表示される' do
        expect(page).to have_content '会員登録'
      end
      it 'nameフォームが表示される' do
        expect(page).to have_field 'customer[name]'
      end
      it 'emailフォームが表示される' do
        expect(page).to have_field 'customer[email]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'customer[password]'
      end
      it 'password_confirmationフォームが表示される' do
        expect(page).to have_field 'customer[password_confirmation]'
      end
      it '新規登録ボタンが表示される' do
        expect(page).to have_button '新規登録'
      end
    end

    context '新規登録成功のテスト' do
      before do
        fill_in 'customer[name]', with: Faker::Lorem.characters(number: 10)
        fill_in 'customer[email]', with: Faker::Internet.email
        fill_in 'customer[password]', with: 'password'
        fill_in 'customer[password_confirmation]', with: 'password'
      end

      it '正しく新規登録される' do
        expect { click_button '新規登録' }.to change(Customer.all, :count).by(1)
      end
      it '新規登録後のリダイレクト先が、新規登録できたユーザの詳細画面になっている' do
        click_button '新規登録'
        expect(current_path).to eq '/public/customers/' + Customer.last.id.to_s
      end
    end
  end

  describe 'ユーザログイン' do
    let(:customer) { create(:customer) }

    before do
      visit new_customer_session_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/customers/sign_in'
      end
      it '「ログイン」と表示される' do
        expect(page).to have_content 'ログイン'
      end
      it 'emailフォームが表示される' do
        expect(page).to have_field 'customer[email]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'customer[password]'
      end
      it 'Log inボタンが表示される' do
        expect(page).to have_button 'ログイン'
      end
      it 'nameフォームは表示されない' do
        expect(page).not_to have_field 'customer[name]'
      end
    end

    context 'ログイン成功のテスト' do
      before do
        fill_in 'customer[email]', with: customer.email
        fill_in 'customer[password]', with: customer.password
        click_button 'ログイン'
      end

      it 'ログイン後のリダイレクト先が、ログインしたユーザの詳細画面になっている' do
        expect(current_path).to eq '/public/customers/' + customer.id.to_s
      end
    end

    context 'ログイン失敗のテスト' do
      before do
        fill_in 'customer[email]', with: ''
        fill_in 'customer[password]', with: ''
        click_button 'ログイン'
      end

      it 'ログインに失敗し、ログイン画面にリダイレクトされる' do
        expect(current_path).to eq '/customers/sign_in'
      end
    end
  end

  describe 'ヘッダーのテスト: ログインしている場合' do
    let(:customer) { create(:customer) }

    before do
      visit new_customer_session_path
      fill_in 'customer[email]', with: customer.email
      fill_in 'customer[password]', with: customer.password
      click_button 'ログイン'
    end

    context 'ヘッダーの表示を確認' do
      it 'SapphireRoomsリンクが表示される: 左上から1番目のリンクが「SapphireRooms」である' do
        root_link = find_all('a')[0].text
        expect(root_link).to match(/SapphireRooms/)
      end
      it 'ホームリンクが表示される: 左上から2番目のリンクが「ホーム」である' do
        root_link = find_all('a')[1].text
        expect(root_link).to match(/ホーム/)
      end
      it '会員一覧リンクが表示される: 左上から3番目のリンクが「会員一覧」である' do
        users_link = find_all('a')[2].text
        expect(users_link).to match(/会員一覧/)
      end
      it '投稿リンクが表示される: 左上から4番目のリンクが「投稿」である' do
        books_link = find_all('a')[3].text
        expect(books_link).to match(/投稿/)
      end
      it 'レビューリンクが表示される: 左上から5番目のリンクが「レビュー」である' do
        rating_link = find_all('a')[4].text
        expect(rating_link).to match(/レビュー/)
      end
      it 'ログアウトリンクが表示される: 左上から5番目のリンクが「ログアウト」である' do
        logout_link = find_all('a')[5].text
        expect(logout_link).to match(/ログアウト/)
      end
    end
  end

  describe 'ユーザログアウトのテスト' do
    let(:customer) { create(:customer) }

    before do
      visit new_customer_session_path
      fill_in 'customer[email]', with: customer.email
      fill_in 'customer[password]', with: customer.password
      click_button 'ログイン'
      logout_link = find_all('a')[4].text
      logout_link = logout_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
      click_link logout_link
    end

    context 'ログアウト機能のテスト' do
      it 'ログアウト後のリダイレクト先が、トップになっている' do
        expect(current_path).to eq '/'
      end
    end
  end
end