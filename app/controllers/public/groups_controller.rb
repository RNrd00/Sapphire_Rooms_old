class Public::GroupsController < ApplicationController
    before_action :ensure_correct_customer, only: [:edit, :update]
    before_action :authenticate_customer!
    before_action :move_to_sign_in, expect: [:index, :show, :edit, :update, :new, :create]
    
    def new
        @group = Group.new
    end
    
    def index
        @book = Book.new
        @groups = Group.all
    end
    
    def show
        @book = Book.new
        @group = Group.find(params[:id])
    end
    
    def create
        @group = Group.new(group_params)
        @group.owner_id = current_customer.id
        if @group.save
            redirect_to public_groups_path
        else
            render 'new'
        end
    end
    
    def edit
    end
    
    def update
        if @group.update(group_params)
            redirect_to public_groups_path
        else
            render "edit"
        end
    end
    
    private
    
    def group_params
        params.require(:group).permit(:name, :introduction, :image)
    end
    
    def ensure_correct_customer
        @group = Group.find(params[:id])
        unless @group.owner_id == current_customer.id
            redirect_to public_groups_path
        end
    end
    
  def move_to_sign_in
      unless customer_signed_in? || admin_signed_in?
          redirect_to new_customer_session_path
      end
  end
end