class Public::NotificationsController < ApplicationController
  before_action :move_to_sign_in, expect: [:index]

  def index
    return if admin_signed_in?

    @notifications = current_customer.passive_notifications.page(params[:page])
    @notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
  end

  private
    def move_to_sign_in
      return if customer_signed_in? || admin_signed_in?

      redirect_to new_customer_session_path, notice: "ログインしてください。"
    end
end
