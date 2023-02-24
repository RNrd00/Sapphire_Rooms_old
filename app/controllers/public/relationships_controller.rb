class Public::RelationshipsController < ApplicationController
  before_action :move_to_sign_in, expect: %i[followings followers create destroy]
  before_action :exist_customer?, only: %i[followings followers create destroy]

  def create
    @customer = Customer.find(params[:customer_id])
    current_customer.follow(@customer)
    @customer.create_notification_follow!(current_customer)
  end

  def destroy
    @customer = Customer.find(params[:customer_id])
    current_customer.unfollow(@customer)
  end

  def followings
    customer = Customer.find(params[:customer_id])
    @customers = customer.followings.page(params[:page])
    @book = customer.books.page(params[:page])
  end

  def followers
    customer = Customer.find(params[:customer_id])
    @customers = customer.followers.page(params[:page])
    @book = customer.books.page(params[:page])
  end

  private
    def exist_customer?
      return if Customer.find_by(id: params[:customer_id])

      redirect_to root_path, notice: "申し訳ございませんが、そのページは削除されているか元から存在しません。"
    end

    def move_to_sign_in
      return if customer_signed_in? || admin_signed_in?

      redirect_to new_customer_session_path, notice: "ログインしてください。"
    end
end
