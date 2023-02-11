class Public::EventNoticesController < ApplicationController
  before_action :move_to_sign_in, expect: [:new, :create, :sent]
    
  def new
    @group = Group.find(params[:group_id])
  end
  
  def create
    
    @group = Group.find(params[:group_id])
    @name = params[:name]
    @introduction = params[:introduction] 
    
    event = { 
      :group => @group, 
      :name => @name, 
      :introduction => @introduction
      
    }
    
    EventMailer.send_notifications_to_group(event)
    
    render :sent
  end
  
  def sent
    redirect_to public_group_path(params[:group_id])
  end
  
  def move_to_sign_in
    unless customer_signed_in? || admin_signed_in?
      redirect_to new_customer_session_path
    end
  end
end
