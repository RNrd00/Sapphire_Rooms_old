class Public::CustomersController < ApplicationController
    before_action :move_to_sign_in, expect: [:index, :show, :edit, :update, :like]
    before_action :ensure_guest_customer, only: [:edit]
    before_action :set_customer, only: [:likes]
    before_action :ensure_correct_customer, only: [:edit, :update]
    before_action :exist_customer?, only:[:show, :edit, :update, :destroy]

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
            redirect_to public_customer_path(current_customer), notice: 'プロフィールの更新に成功しました！'
        else
            render 'edit'
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
        @customer =  Customer.find(params[:customer_id])
        @customer.released! unless @customer.released?
        redirect_to request.referer, notice: 'このアカウントをブロック解除しました'
    end

    def nonrelease
        @customer =  Customer.find(params[:customer_id])
        @customer.nonreleased! unless @customer.nonreleased?
        redirect_to request.referer, notice: 'このアカウントをブロックしました'
    end

    private

    def customer_params
        params.require(:customer).permit(:name, :introduce, :profile_image)
    end

    def set_customer
        @customer = Customer.find(params[:id])
    end

    def exist_customer?
        unless Customer.find_by(id: params[:id])
            redirect_to root_path, notice: '申し訳ございませんが、そのページは削除されているか元から存在しません。'
        end
    end

    def ensure_guest_customer
        @customer = Customer.find(params[:id])
        if @customer.name == "guestuser"
            redirect_to public_customer_path(current_customer), notice:'ゲストユーザーはプロフィール編集画面へ遷移できません。'
        end
    end

    def ensure_correct_customer
        @customer = Customer.find(params[:id])
        unless @customer == current_customer
            redirect_to public_customer_path(current_customer)
        end
    end

  def move_to_sign_in
      unless customer_signed_in? || admin_signed_in?
          redirect_to new_customer_session_path
      end
  end
end