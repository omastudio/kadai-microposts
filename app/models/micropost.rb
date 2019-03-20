class Micropost < ApplicationRecord
  belongs_to :user
  
  validates :content, presence: true, length: { maximum: 255 }
  
  #お気に入りされている投稿
  has_many :favorites
  
  has_many :users_add_to_favorites, through: :favorites, source: :user, foreign_key: 'user_id'
end
