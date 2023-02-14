class Public::RelationshipsController < ApplicationController
    before_action :move_to_sign_in, expect: [:followings, :followers, :create, :destroy]
    
    def create
        customer = Customer.find(params[:customer_id])
        current_customer.follow(customer)
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
      unless customer_signed_in? || admin_signed_in?
          redirect_to new_customer_session_path
      end
    end
end
