class CleanupPosts < ActiveRecord::Migration[7.2]
  def up
    # 本番以外では何もしない（事故防止）
    return unless Rails.env.production?

    say_with_time "Destroying ALL posts (and dependents) in production" do
      # まずはコールバックを動かして安全に削除
      # has_many :likes, dependent: :destroy / 通知の dependent などが効く
      Post.find_each(&:destroy)
    rescue ActiveRecord::InvalidForeignKey
      # もし dependent が未設定で FK で止まった場合のフォールバック
      like_ids = Like.pluck(:id)
      Notification.where(notifiable_type: "Like", notifiable_id: like_ids).delete_all
      Like.delete_all
      Post.delete_all
    end
  end

  def down
    # 元に戻す必要がない一度きりの処理なので空でOK
  end
end
