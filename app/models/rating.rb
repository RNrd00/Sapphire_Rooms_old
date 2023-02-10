class Rating < ApplicationRecord
    belongs_to :customer
    
    validates :name, presence: true
    validates :introduction, presence: true
end
