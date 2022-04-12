class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  # 自分がフォローされる（被フォロー）側の関係性
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # 被フォロー関係を通じて参照→自分をフォローしている人
  has_many :followers, through: :reverse_of_relationships, source: :follower

  # 自分がフォローする（与フォロー）側の関係性
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # 与フォロー関係を通じて参照→自分がフォローしている人
  has_many :followings, through: :relationships, source: :followed

#relationshipsモデルから架空のモデル（reverse_of_relationships,followers,relationships,followings）を作り出してる
#４つのモデルを作ることも可能だが一つのモデルに纏めといた方が変更もしやすい、見やすい、処理がしやすい
#reverse_of_relationshipsモデルにRelationshipモデルからfollowed_id
#followersモデルにreverse_of_relationships内で残りのfollower（follower_id）を取り出す

  has_many :entries
  has_many :messages
  has_many :rooms, through: :entries
  has_many :add_impressions_count_to_books, dependent: :destroy
 
  
  has_one_attached :profile_image


  validates :name, uniqueness: true, length: { minimum: 2, maximum: 20 }
  validates :introduction,length: { maximum: 50 }

  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  # フォローしたときの処理
  def follow(user)
    relationships.create(followed_id: user.id)
  end

  # フォローを外すときの処理
  def unfollow(user)
    relationships.find_by(followed_id: user.id).destroy
  end

  # フォローしているか判定
  def following?(user)
    followings.include?(user)
  end

  # 検索方法分岐
  def self.search_for(content,method)
    if method == "perfect"
      User.where(name: content)
    elsif method == "forward"
      User.where("name LIKE ?",content+"%")
    elsif method == "backward"
      User.where("name LIKE ?","%"+content)
    elsif method == "partial"
      User.where("name LIKE ?","%"+content+"%")
    else
      User.all
    end
  end
end
