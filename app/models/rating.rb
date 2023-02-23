class Rating < ApplicationRecord
  belongs_to :customer
  has_many :rating_tags, dependent: :destroy
  has_many :tags, through: :rating_tags

  validates :name, presence: true, length: { maximum: 100 }
  validates :introduction, presence: true, length: { maximum: 10_000 }

  def save_tags(saverating_tags)
    current_tags = tags.pluck(:name) unless tags.nil?
    old_tags = current_tags - saverating_tags
    new_tags = saverating_tags - current_tags

    old_tags.each { |old_name| tags.delete Tag.find_by(name: old_name) }

    new_tags.each do |new_name|
      rating_tag = Tag.find_or_create_by(name: new_name)
      tags << rating_tag
    end
  end

  def self.search_for(content, method)
    if method == "perfect"
      Rating.where(name: content)
    elsif method == "forward"
      Rating.where("name LIKE ?", content + "%")
    elsif method == "backward"
      Rating.where("name LIKE ?", "%" + content)
    else
      Rating.where("name LIKE ?", "%" + content + "%")
    end
  end
end
