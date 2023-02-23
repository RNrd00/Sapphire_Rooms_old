class Public::CustomersController < ApplicationController
  before_action :exist_customer?, only: %i[show edit update destroy likes]
  before_action :move_to_sign_in, expect: %i[index show edit update like]
  before_action :ensure_correct_customer, only: %i[edit update]
  before_action :ensure_guest_customer, only: [:edit, :unsubscribe, :withdrawal]
  before_action :set_customer, only: [:likes]

  def index
    @customer = Customer.page(params[:page])
  end

  def show
    @customer = Customer.find(params[:id])
    @book = @customer.books.page(params[:page])
    @today_book = @book.created_today
    @yesterday_book = @book.created_yesterday
    @this_week_book = @book.created_this_week
    @last_week_book = @book.created_last_week
  end

  def edit
    @customer = Customer.find(params[:id])
  end

  def update
    @customer = Customer.find(params[:id])
    if @customer.update(customer_params)
      redirect_to public_customer_path(current_customer), notice: "プロフィールの更新に成功しました！"
    else
      render "edit"
    end
  end

  def likes
    likes = Favorite.where(customer_id: @customer.id).pluck(:book_id)
    @like_books = Book.find(likes)
  end

  def daily_posts
    customer = Customer.find(params[:customer_id])
    @books = customer.books.where(created_at: params[:created_at].to_date.all_day)
    render :daily_posts_form
  end

  def release
    @customer = Customer.find(params[:customer_id])
    @customer.released! unless @customer.released?
    redirect_to request.referer, notice: "このアカウントをブロック解除しました"
  end

  def nonrelease
    @customer = Customer.find(params[:customer_id])
    @customer.nonreleased! unless @customer.nonreleased?
    redirect_to request.referer, notice: "このアカウントをブロックしました"
  end

  def unsubscribe
  end

  def withdrawal
    if admin_signed_in?
      @customer = Customer.find(params[:customer_id])
    else
      @customer = current_customer
    end
    @customer.update(is_active: false)
    reset_session
    redirect_to root_path, notice: "退会処理を実行いたしました"
  end

  private
    def customer_params
      params.require(:customer).permit(:name, :introduce, :profile_image)
    end

    def exist_customer?
      return if Customer.find_by(id: params[:id])

      redirect_to root_path, notice: "申し訳ございませんが、そのページは削除されているか元から存在しません。"
    end

    def set_customer
      @customer = Customer.find(params[:id])
    end

    def ensure_correct_customer
      @customer = Customer.find(params[:id])
      return if @customer == current_customer

      if admin_signed_in?
        redirect_to root_path
      else
        redirect_to public_customer_path(current_customer), notice: "他のユーザーの編集ページには遷移出来ません"
      end
    end

    def ensure_guest_customer
      if !admin_signed_in?
        return unless current_customer.name == "guestuser"

        redirect_to public_customer_path(current_customer), notice: "ゲストユーザーはプロフィール編集画面や退会画面へは遷移できません。"
      end
    end

    def move_to_sign_in
      return if customer_signed_in? || admin_signed_in?

      redirect_to new_customer_session_path, notice: "ログインしてください。"
    end
end
