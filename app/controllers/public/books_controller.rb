class Public::BooksController < ApplicationController
  before_action :exist_book?, only: %i[show edit update destroy]
  before_action :move_to_sign_in, expect: %i[index show edit update create destroy]
  before_action :ensure_correct_customer, only: %i[edit update]
  before_action :ensure_guest_customer, only: [:edit]

  def index
    to = Time.current.at_end_of_day
    from = (to - 6.day).at_beginning_of_day
    @books = Book.all.sort do |a, b|
      b.favorites.where(created_at: from...to).size <=>
        a.favorites.where(created_at: from...to).size
    end
    @books = Kaminari.paginate_array(@books).page(params[:page])
    @book = Book.new
    @customer = current_customer
  end

  def show
    @book = Book.find(params[:id])
    if !admin_signed_in? && !ViewCount.find_by(customer_id: current_customer.id, book_id: @book.id)
      current_customer.view_counts.create(book_id: @book.id)
    end
    @book_comment = BookComment.new
    @customer = current_customer
  end

  def edit
    @book = Book.find(params[:id])
  end

  def create
    @book = Book.new(book_params)
    @book.customer_id = current_customer.id
    tag_list = params[:book][:tag_name].split(",")
    if @book.save
      @book.save_tags(tag_list)
      redirect_to public_book_path(@book), notice: "ルーム作成に成功しました！"
    else
      @books = Book.page(params[:page])
      @customer = current_customer
      render "index"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    if @book.delete_key == params[:key] || admin_signed_in?
      @book.destroy
      redirect_to public_books_path, notice: "ルームを削除しました"
    else
      flash[:notice] = "削除パスワードが違います"
      @customer = current_customer
      @book = Book.find(params[:id])
      @book_comment = BookComment.new
      render "show"
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to public_book_path(@book), notice: "編集に成功しました！"
    else
      render "edit"
    end
  end

  private
    def book_params
      params.require(:book).permit(:name, :introduce, :delete_key)
    end

    def exist_book?
      return if Book.find_by(id: params[:id])

      redirect_to root_path, notice: "申し訳ございませんが、そのページは削除されているか元から存在しません。"
    end

    def move_to_sign_in
      return if customer_signed_in? || admin_signed_in?

      redirect_to new_customer_session_path, notice: "ログインしてください。"
    end

    def ensure_guest_customer
      @book = Book.find(params[:id])
      return unless @book.customer.name == "guestuser"

      redirect_to public_books_path, notice: "ゲストユーザーはプロフィール編集画面へ遷移できません。"
    end

    def ensure_correct_customer
      @book = Book.find(params[:id])
      return if @book.customer == current_customer

      redirect_to public_books_path, notice: "他のユーザーの編集ページには遷移できません。"
    end
end
