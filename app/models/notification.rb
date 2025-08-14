class Notification < ApplicationRecord
  belongs_to :notifiable, polymorphic: true

  enum action: { like: 0 }

  # 通知を送ったユーザー
  belongs_to :visitor, class_name: "User"
  # 通知を受け取ったユーザー
  belongs_to :visited, class_name: "User"

  # scopeでレコード取得を容易に
  scope :unread, -> { where(checked: false) }
  scope :read, -> { where(checked: true) }
end
