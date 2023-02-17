class Chat < ApplicationRecord
  belongs_to :customer
  belongs_to :room

  has_many :notifications, dependent: :destroy

  validates :message, presence: true, length: { maximum: 1000 }

  def create_notification_chat!(current_customer, chat_id, room_id, visited_id)
    temp_ids = Chat.select(:customer_id).where(room_id:).where.not(customer_id: current_customer.id).distinct
    temp_ids.each do |temp_id|
      save_notification_chat!(current_customer, chat_id, temp_id['customer_id'])
    end
    save_notification_chat!(current_customer, chat_id, visited_id) if temp_ids.blank?
  end

  def save_notification_chat!(current_customer, chat_id, visited_id)
    notification = current_customer.active_notifications.new(
      chat_id:,
      visited_id:,
      action: 'chat'
    )
    notification.checked = true if notification.visitor_id == notification.visited_id
    notification.save if notification.valid?
  end
end
