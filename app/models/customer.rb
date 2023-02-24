class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :group_customers, dependent: :destroy
  has_many :customer_rooms
  has_many :chats
  has_many :rooms, through: :customer_rooms
  has_many :view_counts, dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :reverse_of_relationships, source: :follower
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followings, through: :relationships, source: :followed
  has_many :active_notifications, class_name: "Notification", foreign_key: "visitor_id", dependent: :destroy
  has_many :passive_notifications, class_name: "Notification", foreign_key: "visited_id", dependent: :destroy

  has_one_attached :profile_image

  validates :name, length: { minimum: 1, maximum: 100 }, uniqueness: true
  validates :introduce, length: { maximum: 10_000 }

  enum status: { nonreleased: 0, released: 1 }

  def get_profile_image
    profile_image.attached? ? profile_image : "no_image.jpg" # 条件演算子でリファクタリング
  end

  def follow(customer)
    relationships.create(followed_id: customer.id)
  end

  def unfollow(customer)
    relationships.find_by(followed_id: customer.id).destroy
  end

  def following?(customer)
    followings.include?(customer)
  end

  def self.search_for(content, method)
    if method == "perfect"
      Customer.where(name: content)
    elsif method == "forward"
      Customer.where("name LIKE ?", content + "%")
    elsif method == "backward"
      Customer.where("name LIKE ?", "%" + content)
    else
      Customer.where("name LIKE ?", "%" + content + "%")
    end
  end

  scope :only_active, -> { where(is_active: true) }

  def create_notification_follow!(current_customer)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and action = ? ", current_customer.id, id, "follow"])
    return unless temp.blank?

    notification = current_customer.active_notifications.new(
      visited_id: id,
      action: "follow"
    )
    notification.save if notification.valid?
  end

  def self.guest
    find_or_create_by!(name: "guestuser", email: "guest@example.com") do |customer|
      customer.password = SecureRandom.urlsafe_base64
      customer.name = "guestuser"
    end
  end
end
