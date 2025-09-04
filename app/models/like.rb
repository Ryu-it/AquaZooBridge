class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post

  has_one :notifications, as: :notifiable, dependent: :destroy

  validates :user_id, uniqueness: { scope: :post_id }

  # いいね作成時に通知を作成
  after_create :create_notification

  private

  def create_notification
    # 自分の投稿には通知しない
    return if user == post.user

    # インスタンスを生成して保存する
    Notification.create!(
      visitor: user,        # いいねした人
      visited: post.user,   # いいねされた人
      notifiable: self,     # このいいねレコード
      action: :like
    )
  end
end
