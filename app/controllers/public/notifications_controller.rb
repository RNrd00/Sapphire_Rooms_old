class Public::NotificationsController < ApplicationController
  before_action :move_to_sign_in, expect: [:index]

  def index
    if !admin_signed_in?
      @notifications = current_customer.passive_notifications.page(params[:page])
      @notifications.where(checked: false).each do |notification|
        notification.update(checked: true)
      end
    end
  end

  private

  def move_to_sign_in
      unless customer_signed_in? || admin_signed_in?
          redirect_to new_customer_session_path
      end
  end

end