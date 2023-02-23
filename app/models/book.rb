class Book < ApplicationRecord
  belongs_to :customer
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :view_counts, dependent: :destroy
  has_many :book_tags, dependent: :destroy
  has_many :tags, through: :book_tags

  # ラムダ(Proc)を使用。メソッドチェーンも使用。
  has_many :week_favorites, lambda {
                              where(created_at: ((Time.current.at_end_of_day - 6.day).at_beginning_of_day)..(Time.current.at_end_of_day))
                            }, class_name: "Favorite"

  validates :name, length: { minimum: 1, maximum: 100 }
  validates :introduce, length: { minimum: 1, maximum: 10000 }
  validates :delete_key, format: { with: /\A\w{1,100}\z/i } # リファクタリングで正規表現を使用しました！

  scope :created_today, -> { where(created_at: Time.zone.now.all_day) }
  scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) }
  scope :created_this_week, -> { where(created_at: 6.day.ago.beginning_of_day..Time.zone.now.end_of_day) }
  scope :created_last_week, -> { where(created_at: 2.week.ago.beginning_of_day..1.week.ago.end_of_day) }

  scope :created_today, -> { where(created_at: Time.zone.now.all_day) }
  scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) }
  scope :created_2day_ago, -> { where(created_at: 2.day.ago.all_day) }
  scope :created_3day_ago, -> { where(created_at: 3.day.ago.all_day) }
  scope :created_4day_ago, -> { where(created_at: 4.day.ago.all_day) }
  scope :created_5day_ago, -> { where(created_at: 5.day.ago.all_day) }
  scope :created_6day_ago, -> { where(created_at: 6.day.ago.all_day) }

  def save_tags(savebook_tags)
    current_tags = tags.pluck(:name) unless tags.nil?
    old_tags = current_tags - savebook_tags
    new_tags = savebook_tags - current_tags

    old_tags.each { |old_name| tags.delete Tag.find_by(name: old_name) }

    new_tags.each do |new_name|
      book_tag = Tag.find_or_create_by(name: new_name)
      tags << book_tag
    end
  end

  def favorited_by?(customer)
    favorites.where(customer_id: customer.id).exists?
  end

  def self.search_for(content, method)
    if method == "perfect"
      Book.where(introduce: content)
    elsif method == "forward"
      Book.where("introduce LIKE ?", content + "%")
    elsif method == "backward"
      Book.where("introduce LIKE ?", "%" + content)
    else
      Book.where("introduce LIKE ?", "%" + content + "%")
    end
  end
end
