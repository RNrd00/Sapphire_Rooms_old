class Book < ApplicationRecord
    belongs_to :customer
    
    validates :name, presence:true
    validates :delete_key, format:{with: /\A\w{1,100}\z/i } #リファクタリングで正規表現を使用しました！
    
    def favorited_by?(customer)
        favorites.where(customer_id: customer.id).exists?
    end
end
