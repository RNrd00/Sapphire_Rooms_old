class BookComment < ApplicationRecord
  belongs_to :customer
  belongs_to :book

  validates :comment, length: { minimum: 1, maximum: 2000 }
end
