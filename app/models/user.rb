class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy


  has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy #フォローするユーザのid
  has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy #フォローされるユーザのid
  has_many :follower_users, through: :followed, source: :follower  #フォローしている人
  has_many :following_users, through: :follower, source: :followed  #フォローされている人

  # ユーザーをフォローする
  def follow(another_user)
    unless self == another_user
      self.relationships.find_or_create_by(follower_id: another_user.id)
    end
  end

  # ユーザーのフォローを外す
  def unfollow(user_id)
    follower.find_by(followed_id: user_id).destroy
  end

  # フォローしていればtrueを返す
  def following?(user)
    self.following_users.include?(user)
  end

  validates :name, uniqueness: true, length: { minimum: 2, maximum: 20 }
  validates :introduction,length: { maximum: 50 }

  has_one_attached :profile_image

  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end
end
