class Public::CustomersController < ApplicationController
    before_action :ensure_guest_customer, only: [:edit]
    
    def index
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
    
    private
    
    def customer_params
        params.require(:customer).permit(:name, :introduce, :profile_image)
    end
    
    def ensure_guest_customer
        @customer =Customer.find(params[:id])
        if @customer.name == "guestuser"
            redirect_to public_customer_path(current_customer), notice:'ゲストユーザーはプロフィール編集画面へ遷移できません。'
        end
    end
end
