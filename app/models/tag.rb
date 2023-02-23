class Tag < ApplicationRecord
  has_many :rating_tags, dependent: :destroy, foreign_key: "tag_id"
  has_many :ratings, through: :rating_tags
  has_many :book_tags, dependent: :destroy, foreign_key: "tag_id"
  has_many :books, through: :book_tags

  scope :merge_ratings, ->(tags) { }

  def self.search_ratings_for(content, method)
    tags = if method == "perfect"
      Tag.where(name: content)
    elsif method == "forward"
      Tag.where("name LIKE ?", content + "%")
    elsif method == "backward"
      Tag.where("name LIKE ?", "%" + content)
    else
      Tag.where("name LIKE ?", "%" + content + "%")
    end

    tags.inject(init = []) { |result, tag| result + tag.ratings }
  end

  def self.search_books_for(content, method)
    tags = if method == "perfect"
      Tag.where(name: content)
    elsif method == "forward"
      Tag.where("name LIKE ?", content + "%")
    elsif method == "backward"
      Tag.where("name LIKE ?", "%" + content)
    else
      Tag.where("name LIKE ?", "%" + content + "%")
    end

    tags.inject(init = []) { |result, tag| result + tag.books }
  end
end
