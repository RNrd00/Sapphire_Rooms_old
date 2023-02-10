class Public::EventNoticesController < ApplicationController
    
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
  
end
