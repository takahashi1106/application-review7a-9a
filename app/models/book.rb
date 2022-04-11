class Book < ApplicationRecord
  # 追記
is_impressionable counter_cache: true

  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user
  has_many :book_comments, dependent: :destroy
  has_many :add_impressions_count_to_books, dependent: :destroy
  
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}


    def favorited_by?(user)
    favorites.exists?(user_id: user.id)
    end


    # 検索方法分岐
   def self.search_for(content,method)
    if method == "perfect"
      Book.where(title: content)
    elsif method == "forward"
      Book.where("title LIKE?",content+"%")
    elsif method == 'backward'
      Book.where("title LIKE?","%"+content)
    elsif method == 'partial'
      Book.where("title LIKE ?", "%"+content+"%")
    else
      Book.all
    end
   end
end
