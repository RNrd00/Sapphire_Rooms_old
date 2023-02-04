class Public::CustomersController < ApplicationController
    before_action :authenticate_customer!
    before_action :ensure_guest_customer, only: [:edit]
    before_action :set_customer, only: [:likes]
    
    def index
        @customer = Customer.all
    end
    
    def show
        @customer = Customer.find(params[:id])
        @book = @customer.books
    end
    
    def edit
        @customer = Customer.find(params[:id])
    end
    
    def update
        @customer = Customer.find(params[:id])
        @customer.update(customer_params)
        redirect_to public_customer_path(current_customer)
    end
    
    def likes
        likes = Favorite.where(customer_id: @customer.id).pluck(:book_id)
        @like_books = Book.find(likes)
    end
    
    private
    
    def customer_params
        params.require(:customer).permit(:name, :introduce, :profile_image)
    end
    
    def set_customer
        @customer = Customer.find(params[:id])
    end
    
    def ensure_guest_customer
        @customer =Customer.find(params[:id])
        if @customer.name == "guestuser"
            redirect_to public_customer_path(current_customer), notice:'ゲストユーザーはプロフィール編集画面へ遷移できません。'
        end
    end
end
