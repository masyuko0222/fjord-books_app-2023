class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  # 郵便番号・住所・自己紹介の制限
  validates :post_code, presence: true
  validates :address, presence: true
  validates :introduction, length: { maximum: 300 }
end
