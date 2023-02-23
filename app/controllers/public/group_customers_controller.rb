class Public::GroupCustomersController < ApplicationController
  before_action :move_to_sign_in, expect: %i[create destroy]

  def create
    group_customer = current_customer.group_customers.new(group_id: params[:group_id])
    group_customer.save
    redirect_to request.referer
  end

  def destroy
    group_customer = current_customer.group_customers.find_by(group_id: params[:group_id])
    group_customer.destroy
    redirect_to request.referer
  end

  def move_to_sign_in
    return if customer_signed_in? || admin_signed_in?

    redirect_to new_customer_session_path, notice: "ログインしてください。"
  end
end
