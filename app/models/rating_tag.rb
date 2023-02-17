class RatingTag < ApplicationRecord
  belongs_to :rating
  belongs_to :tag
end
