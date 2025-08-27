class NotificationsController < ApplicationController
  before_action :authenticate_user!, only: %i[index mark_notifications_as_read]
  def index
    @notifications = current_user.passive_notifications
                                 .includes(:visitor, notifiable: :facility)
                                 .order(created_at: :desc)
                                 .page(params[:page]).per(9)
  end

  # 未読通知を一気に既読
  def mark_notifications_as_read
    current_user.passive_notifications.unread.update_all(checked: true)
    redirect_to notifications_path, notice: "すべて既読にしました"
  end
end
