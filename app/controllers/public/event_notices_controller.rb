class Public::EventNoticesController < ApplicationController
  before_action :move_to_sign_in, expect: %i[new create sent]
  before_action :exist_customer?, only: %i[new create sent]
  before_action :ensure_guest_customer, only: %i[new create sent]
  before_action :ensure_correct_customer, only: %i[new create sent]

  def new
    @group = Group.find(params[:group_id])
  end

  def create
    @group = Group.find(params[:group_id])
    @name = params[:name]
    @introduction = params[:introduction]

    event = {
      group: @group,
      name: @name,
      introduction: @introduction

    }

    EventMailer.send_notifications_to_group(event)
    render :sent
  end

  def sent
    redirect_to public_group_path(params[:group_id])
  end

  def move_to_sign_in
    return if customer_signed_in? || admin_signed_in?

    redirect_to new_customer_session_path, notice: "ログインしてください。"
  end

  def exist_customer?
    return if Group.find_by(id: params[:group_id])

    redirect_to root_path, notice: "申し訳ございませんが、そのページは削除されているか元から存在しません。"
  end

  def ensure_guest_customer
    if !admin_signed_in?
      return unless current_customer.name == "guestuser"

      redirect_to public_customer_path(current_customer), notice: "ゲストユーザーはプロフィール編集画面や退会画面へは遷移できません。"
    end
  end

  def ensure_correct_customer
    unless admin_signed_in?
      @group = Group.find(params[:group_id])
      return if @group.owner_id == current_customer.id

      redirect_to public_groups_path, notice: "他のユーザーへの編集画面へは遷移できません。"
    end
  end
end
