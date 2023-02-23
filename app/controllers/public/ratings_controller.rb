class Public::RatingsController < ApplicationController
  before_action :exist_rating?, only: [:destroy]
  before_action :move_to_sign_in, expect: [:index]

  def index
    @ratings = Rating.page(params[:page]).order(params[:sort])
    @rating = Rating.new
  end

  def create
    @rating = Rating.new(rating_params)
    @rating.customer_id = current_customer.id
    tag_list = params[:rating][:tag_name].split(",")
    if @rating.save
      @rating.save_tags(tag_list)
      redirect_to request.referer, notice: "レビューを投稿しました！"
    else
      @ratings = Rating.page(params[:page]).order(params[:sort])
      render "index"
    end
  end

  def destroy
    @rating = Rating.find(params[:id])
    @rating.destroy
    redirect_to root_path, notice: "レビューを削除しました"
  end

  private
    def rating_params
      params.require(:rating).permit(:name, :introduction, :rate)
    end

    def exist_rating?
      return if Rating.find_by(id: params[:id])

      redirect_to root_path, notice: "そのページは削除済みです。"
    end

    def move_to_sign_in
      return if customer_signed_in? || admin_signed_in?

      redirect_to new_customer_session_path, notice: "ログインしてください。"
    end
end
