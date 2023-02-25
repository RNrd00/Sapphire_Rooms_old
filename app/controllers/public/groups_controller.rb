class Public::GroupsController < ApplicationController
  before_action :move_to_sign_in, expect: %i[index show edit update new create destroy]
  before_action :exist_group?, only: %i[show edit update destroy]
  before_action :ensure_correct_customer, only: %i[edit update destroy]
  before_action :ensure_guest_customer, only: %i[create edit update destroy]

  def new
    @group = Group.new
  end

  def index
    @book = Book.new
    @groups = Group.page(params[:page])
  end

  def show
    @book = Book.new
    @group = Group.find(params[:id])
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_customer.id
    if @group.save
      redirect_to public_groups_path, notice: "グループを作成しました！"
    else
      render "new"
    end
  end

  def edit; end

  def update
    if @group.update(group_params)
      redirect_to public_groups_path, notice: "グループを編集しました！"
    else
      render "edit"
    end
  end

  def destroy
    if admin_signed_in?
      @group = Group.find(params[:id])
    end
    @group.destroy
    redirect_to public_groups_path, notice: "グループを削除しました"
  end

  private
    def group_params
      params.require(:group).permit(:name, :introduction, :image)
    end

    def move_to_sign_in
      return if customer_signed_in? || admin_signed_in?

      redirect_to new_customer_session_path, notice: "ログインしてください。"
    end

    def exist_group?
      return if Group.find_by(id: params[:id])

      redirect_to root_path, notice: "申し訳ございませんが、そのページは削除されているか元から存在しません。"
    end

    def ensure_correct_customer
      unless admin_signed_in?
        @group = Group.find(params[:id])
        return if @group.owner_id == current_customer.id

        redirect_to public_groups_path, notice: "他のユーザーへの編集画面へは遷移できません。"
      end
    end

    def ensure_guest_customer
      return if admin_signed_in?
      return unless current_customer.name == "guestuser"

      redirect_to public_customer_path(current_customer), notice: "ゲストユーザーはグループ画面へ遷移できません。"
    end
end
