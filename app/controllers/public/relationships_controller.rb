class Public::RelationshipsController < ApplicationController
  before_action :move_to_sign_in, expect: %i[followings followers create destroy]

  def create
    customer = Customer.find(params[:customer_id])
    current_customer.follow(customer)
    customer.create_notification_follow!(current_customer)
    redirect_to request.referer
  end

  def destroy
    customer = Customer.find(params[:customer_id])
    current_customer.unfollow(customer)
    redirect_to request.referer
  end

  def followings
    customer = Customer.find(params[:customer_id])
    @customers = customer.followings
    @book = customer.books.page(params[:page])
  end

  def followers
    customer = Customer.find(params[:customer_id])
    @customers = customer.followers
    @book = customer.books.page(params[:page])
  end

  private

  def move_to_sign_in
    return if customer_signed_in? || admin_signed_in?

    redirect_to new_customer_session_path, notice: 'ログインしてください。'
  end
end
