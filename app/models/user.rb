class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :likes

  # 自分が送った通知
  has_many :active_notifications, class_name: "Notification",
  foreign_key: "visitor_id",
  dependent: :destroy

  # 自分が受け取った通知
  has_many :passive_notifications, class_name: "Notification",
  foreign_key: "visited_id",
  dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
