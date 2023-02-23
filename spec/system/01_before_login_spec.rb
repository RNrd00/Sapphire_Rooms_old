require "rails_helper"

describe "[STEP1] ユーザログイン前のテスト" do
  describe "トップ画面のテスト" do
    before do
      visit root_path
    end

    context "表示内容の確認" do
      it "URLが正しい" do
        expect(current_path).to eq "/"
      end
      it "最初のページに「自分が話したい話題について話し合うルームを自由に作成することが出来ます。」と表示される？" do
        expect(page).to have_content "自分が話したい話題について話し合うルームを自由に作成することが出来ます。"
      end
    end
  end

  describe "アバウト画面のテスト" do
    before do
      visit "/public/home/about"
    end

    context "表示内容の確認" do
      it "URLが正しい" do
        expect(current_path).to eq "/public/home/about"
      end
    end
  end

  describe "辞典画面のテスト" do
    before do
      visit "/public/dictionaries"
    end

    context "表示内容の確認" do
      it "URLが正しい" do
        expect(current_path).to eq "/public/dictionaries"
      end
      it "最初のページに「ここは辞典ページです。」と表示される？" do
        expect(page).to have_content "ここは辞典ページです。"
      end
      it "SNSページに繋がるリンクは存在する？" do
        expect(page).to have_link "SNSとは"
      end
    end
  end

  describe "SNS説明ページのテスト" do
    before do
      visit "/public/dictionaries/sns"
    end

    context "表示内容の確認" do
      it "URLが正しい" do
        expect(current_path).to eq "/public/dictionaries/sns"
      end
      it "最初のページに「SNSとは？」と表示される？" do
        expect(page).to have_content "SNSとは？"
      end
      it "Snapchatに繋がるリンクは存在する？" do
        expect(page).to have_content "Snapchat"
      end
      it "TikTokに繋がるリンクは存在する？" do
        expect(page).to have_content "TikTok"
      end
    end
  end

  describe "ヘッダーのテスト: ログインしていない場合" do
    before do
      visit root_path
    end

    context "表示内容の確認" do
      it "SapphireRoomsリンクが表示される: 左上から1番目のリンクが「SapphireRooms」である" do
        root_link = find_all("a")[0].text
        expect(root_link).to match(/SapphireRooms/)
      end
      it "ホームリンクが表示される: 左上から2番目のリンクが「ホーム」である" do
        root_link = find_all("a")[1].text
        expect(root_link).to match(/ホーム/)
      end
      it "サイト紹介リンクが表示される: 左上から3番目のリンクが「サイト紹介」である" do
        about_link = find_all("a")[2].text
        expect(about_link).to match(/サイト紹介/)
      end
      it "会員登録リンクが表示される: 左上から4番目のリンクが「辞典」である" do
        signup_link = find_all("a")[3].text
        expect(signup_link).to match(/辞典/)
      end
      it "会員登録リンクが表示される: 左上から4番目のリンクが「会員登録」である" do
        signup_link = find_all("a")[4].text
        expect(signup_link).to match(/会員登録/)
      end
      it "ログインリンクが表示される: 左上から5番目のリンクが「ログイン」である" do
        login_link = find_all("a")[5].text
        expect(login_link).to match(/ログイン/)
      end
      it "ゲストログインリンクが表示される: 左上から6番目のリンクが「ゲストログイン」である" do
        guestlogin_link = find_all("a")[6].text
        expect(guestlogin_link).to match(/ゲストログイン/)
      end
      it "管理者ログインリンクが表示される: 左上から7番目のリンクが「管理者ログイン」である" do
        admin_link = find_all("a")[7].text
        expect(admin_link).to match(/管理者ログイン/)
      end
    end

    context "リンクの内容を確認" do
      subject { current_path }

      it "SapphireRoomsを押すと、トップ画面に遷移する" do
        root_link = find_all("a")[0].text
        root_link = root_link.delete(" ")
        root_link.delete!("\n")
        click_link root_link
        is_expected.to eq "/"
      end
      it "ホームを押すと、トップ画面に遷移する" do
        root_link = find_all("a")[1].text
        root_link = root_link.delete(" ")
        root_link.delete!("\n")
        click_link root_link
        is_expected.to eq "/"
      end
      it "サイト紹介を押すと、アバウト画面に遷移する" do
        about_link = find_all("a")[2].text
        about_link = about_link.delete("\n").gsub(/\A\s*/, "").gsub(/\s*\Z/, "")
        click_link about_link
        is_expected.to eq "/public/home/about"
      end
      it "辞典を押すと、辞典画面に遷移する" do
        dictionary_link = find_all("a")[3].text
        dictionary_link = dictionary_link.delete("\n").gsub(/\A\s*/, "").gsub(/\s*\Z/, "")
        click_link dictionary_link, match: :first
        is_expected.to eq "/public/dictionaries"
      end
      it "会員登録を押すと、新規登録画面に遷移する" do
        signup_link = find_all("a")[4].text
        signup_link = signup_link.delete("\n").gsub(/\A\s*/, "").gsub(/\s*\Z/, "")
        click_link signup_link, match: :first
        is_expected.to eq "/customers/sign_up"
      end
      it "ログインを押すと、ログイン画面に遷移する" do
        login_link = find_all("a")[5].text
        login_link = login_link.delete("\n").gsub(/\A\s*/, "").gsub(/\s*\Z/, "")
        click_link login_link, match: :first
        is_expected.to eq "/customers/sign_in"
      end
      it "ゲストログインを押すと、ゲストログインする" do
        guestlogin_link = find_all("a")[6].text
        guestlogin_link = guestlogin_link.delete("\n").gsub(/\A\s*/, "").gsub(/\s*\Z/, "")
        click_link guestlogin_link, match: :first
        is_expected.to eq "/"
      end
      it "管理者ログインを押すと、管理者ログイン画面に遷移する" do
        admin_link = find_all("a")[7].text
        admin_link = admin_link.delete("\n").gsub(/\A\s*/, "").gsub(/\s*\Z/, "")
        click_link admin_link, match: :first
        is_expected.to eq "/admin/sign_in"
      end
    end
  end

  describe "ユーザ新規登録のテスト" do
    before do
      visit new_customer_registration_path
    end

    context "表示内容の確認" do
      it "URLが正しい" do
        expect(current_path).to eq "/customers/sign_up"
      end
      it "「会員登録」と表示される" do
        expect(page).to have_content "会員登録"
      end
      it "nameフォームが表示される" do
        expect(page).to have_field "customer[name]"
      end
      it "emailフォームが表示される" do
        expect(page).to have_field "customer[email]"
      end
      it "passwordフォームが表示される" do
        expect(page).to have_field "customer[password]"
      end
      it "password_confirmationフォームが表示される" do
        expect(page).to have_field "customer[password_confirmation]"
      end
      it "新規登録ボタンが表示される" do
        expect(page).to have_button "新規登録"
      end
    end

    context "新規登録成功のテスト" do
      before do
        fill_in "customer[name]", with: Faker::Lorem.characters(number: 10)
        fill_in "customer[email]", with: Faker::Internet.email
        fill_in "customer[password]", with: "password"
        fill_in "customer[password_confirmation]", with: "password"
      end

      it "正しく新規登録される" do
        expect { click_button "新規登録" }.to change(Customer.all, :count).by(1)
      end
      it "新規登録後のリダイレクト先が、ホーム画面になっている" do
        click_button "新規登録"
        expect(current_path).to eq "/"
      end
    end
  end

  describe "ユーザログイン" do
    let(:customer) { create(:customer) }

    before do
      visit new_customer_session_path
    end

    context "表示内容の確認" do
      it "URLが正しい" do
        expect(current_path).to eq "/customers/sign_in"
      end
      it "「ログイン」と表示される" do
        expect(page).to have_content "ログイン"
      end
      it "emailフォームが表示される" do
        expect(page).to have_field "customer[email]"
      end
      it "passwordフォームが表示される" do
        expect(page).to have_field "customer[password]"
      end
      it "ログインボタンが表示される" do
        expect(page).to have_button "ログイン"
      end
      it "nameフォームは表示されない" do
        expect(page).not_to have_field "customer[name]"
      end
    end

    context "ログイン成功のテスト" do
      before do
        fill_in "customer[email]", with: customer.email
        fill_in "customer[password]", with: customer.password
        click_button "ログイン"
      end

      it "ログイン後のリダイレクト先が、ホームページなっている" do
        expect(current_path).to eq "/"
      end
    end

    context "ログイン失敗のテスト" do
      before do
        fill_in "customer[email]", with: ""
        fill_in "customer[password]", with: ""
        click_button "ログイン"
      end

      it "ログインに失敗し、ログイン画面にリダイレクトされる" do
        expect(current_path).to eq "/customers/sign_in"
      end
    end
  end

  describe "ヘッダーのテスト: ログインしている場合" do
    let(:customer) { create(:customer) }

    before do
      visit new_customer_session_path
      fill_in "customer[email]", with: customer.email
      fill_in "customer[password]", with: customer.password
      click_button "ログイン"
    end

    context "ヘッダーの表示を確認" do
      it "SapphireRoomsリンクが表示される: 左上から1番目のリンクが「SapphireRooms」である" do
        root_link = find_all("a")[0].text
        expect(root_link).to match(/SapphireRooms/)
      end
      it "ホームリンクが表示される: 左上から2番目のリンクが「ホーム」である" do
        root_link = find_all("a")[1].text
        expect(root_link).to match(/ホーム/)
      end
      it "会員一覧リンクが表示される: 左上から3番目のリンクが「会員一覧」である" do
        customers_link = find_all("a")[2].text
        expect(customers_link).to match(/会員一覧/)
      end
      it "投稿リンクが表示される: 左上から4番目のリンクが「ルーム」である" do
        books_link = find_all("a")[3].text
        expect(books_link).to match(/ルーム/)
      end
      it "レビューリンクが表示される: 左上から5番目のリンクが「レビュー」である" do
        rating_link = find_all("a")[4].text
        expect(rating_link).to match(/レビュー/)
      end
      it "通知リンクが表示される: 左上から5番目のリンクが「通知」である" do
        logout_link = find_all("a")[5].text
        expect(logout_link).to match(/通知/)
      end
      it "ログアウトリンクが表示される: 左上から6番目のリンクが「グループ一覧」である" do
        logout_link = find_all("a")[6].text
        expect(logout_link).to match(/グループ一覧/)
      end
      it "ログアウトリンクが表示される: 左上から7番目のリンクが「グループ作成」である" do
        logout_link = find_all("a")[7].text
        expect(logout_link).to match(/グループ作成/)
      end
      it "ログアウトリンクが表示される: 左上から8番目のリンクが「退会する」である" do
        logout_link = find_all("a")[8].text
        expect(logout_link).to match(/退会する/)
      end
      it "ログアウトリンクが表示される: 左上から9番目のリンクが「辞典」である" do
        logout_link = find_all("a")[9].text
        expect(logout_link).to match(/辞典/)
      end
      it "ログアウトリンクが表示される: 左上から10番目のリンクが「ログアウト」である" do
        logout_link = find_all("a")[10].text
        expect(logout_link).to match(/ログアウト/)
      end
    end
  end

  describe "ユーザログアウトのテスト" do
    let(:customer) { create(:customer) }

    before do
      visit new_customer_session_path
      fill_in "customer[email]", with: customer.email
      fill_in "customer[password]", with: customer.password
      click_button "ログイン"
      logout_link = find_all("a")[10].text
      logout_link = logout_link.delete("\n").gsub(/\A\s*/, "").gsub(/\s*\Z/, "")
      click_link logout_link
    end

    context "ログアウト機能のテスト" do
      it "ログアウト後のリダイレクト先が、トップになっている" do
        expect(current_path).to eq "/"
      end
    end
  end
end
