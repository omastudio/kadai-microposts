class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  
  #投稿したMicropost
  has_many :microposts
  
  #フォローしているUser達
  has_many :relationships
  
  #中間テーブルを通して自分がフォローしているUser達を取得
  has_many :following_users, through: :relationships, source: :follow
  
  #自分をフォローしているUserへの参照
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  
  #中間テーブルを通してフォローされているUser達を取得
  has_many :followed_users, through: :reverses_of_relationship, source: :user
  
  #お気に入りしているMicropost
  has_many :favorites
  
  has_many :favorite_microposts, through: :favorites, source: :micropost, foreign_key: 'micropost_id'
  
  #フォロー、アンフォローの機能実装
  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.following_users.include?(other_user)
  end
  
  #お気に入り追加、削除の機能実装
  def add_to_favorite(target_post)
    unless target_post.user == self
      self.favorites.find_or_create_by(micropost_id: target_post.id)
    end
  end
  
  def remove_favorite(target_post)
      favorite = self.favorites.find_by(micropost_id: target_post.id)
      favorite.destroy if favorite
  end
  
  def favorite?(target_post)
    self.favorite_microposts.include?(target_post)
  end
  
  #投稿一覧取得の実装
  def feed_microposts
    Micropost.where(user_id: self.following_users + [self.id])
  end
end