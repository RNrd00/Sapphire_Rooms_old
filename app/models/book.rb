class Book < ApplicationRecord
    belongs_to :customer
    has_many :book_comments, dependent: :destroy
    has_many :favorites, dependent: :destroy
    
    #ラムダ(Proc)を使用。メソッドチェーンも使用。
    has_many :week_favorites, -> { where(created_at: ((Time.current.at_end_of_day - 6.day).at_beginning_of_day)..(Time.current.at_end_of_day)) }, class_name: 'Favorite'
    
    validates :name, presence:true
    validates :delete_key, format:{with: /\A\w{1,100}\z/i } #リファクタリングで正規表現を使用しました！
    
    def favorited_by?(customer)
        favorites.where(customer_id: customer.id).exists?
    end
    
    def self.search_for(content, method)
        if method == 'perfect'
            Book.where(introduce: content)
        elsif method == 'forward'
            Book.where('name LIKE ?', content + '%')
        elsif method == 'backward'
            Book.where('name LIKE ?', '%' + content)
        else
            Book.where('name LIKE ?', '%' + content + '%')
        end
    end
end
