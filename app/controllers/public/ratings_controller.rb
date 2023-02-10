class Public::RatingsController < ApplicationController
    before_action :move_to_sign_in, expect: [:index, :create, :destroy]
    
    def index
        @ratings = Rating.all
        @rating = Rating.new
    end
    
    def create
        @rating = Rating.new(rating_params)
        @rating.customer_id = current_customer.id
        if @rating.save
            redirect_to request.referer
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
    
    def move_to_sign_in
        unless customer_signed_in? || admin_signed_in?
            redirect_to new_customer_session_path
        end
    end
end
