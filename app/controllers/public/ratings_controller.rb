class Public::RatingsController < ApplicationController
    before_action :move_to_sign_in, expect: [:index, :create, :destroy]
    before_action :ensure_correct_customer, only: [:destroy]
    before_action :exist_rating?, only:[:destroy]
    
    def index
        @ratings = Rating.all.order(params[:sort])
        @rating = Rating.new
    end
    
    def create
        @rating = Rating.new(rating_params)
        @rating.customer_id = current_customer.id
        tag_list = params[:rating][:tag_name].split(',')
        if @rating.save
           @rating.save_tags(tag_list)
            redirect_to request.referer, notice: 'レビューを投稿しました！'
        else
            @ratings = Rating.all
            render 'index'
        end
    end
    
    def destroy
        @rating = Rating.find(params[:id])
        @rating.destroy
        redirect_to request.referer, notice: 'レビューを削除しました'
    end
    
    private
    
    def rating_params
        params.require(:rating).permit(:name, :introduction, :rate)
    end
    
    def exist_rating?
        unless Rating.find_by(id: params[:id])
            redirect_to root_path, notice: 'そのページは削除済みです。'
        end
    end
    
    def move_to_sign_in
        unless customer_signed_in? || admin_signed_in?
            redirect_to new_customer_session_path
        end
    end
    
    def ensure_correct_customer
        @customer = Customer.find(params[:id])
        unless @customer == current_customer
            redirect_to public_customer_path(current_customer)
        end
    end
end
