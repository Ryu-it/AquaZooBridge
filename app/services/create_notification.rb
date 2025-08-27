class CreateNotification
  def self.url_visit(visitor:, post:)
    Notification.create!(
      visitor: visitor,
      visited: post.user,
      notifiable: post,
      action: :visited_url
    )
  end
end
