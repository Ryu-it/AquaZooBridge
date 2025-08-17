require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe "バリデーション成功" do
    it "いいねの通知が成功する" do
      user = User.create!(name: "太郎", email: "aro@example.com", password: "password")
      user2 = User.create!(name: "夢", email: "yume@example.com", password: "password")
      category = Category.create!(name: "aqua")
      area = Area.create!(name: "北海道")
      facility = Facility.create!(name: "テスト動物園", official_url: "https://example.com")
      post = Post.create!(user: user, category: category, area: area, facility: facility, word: "ワード", body: "本文")
      like = Like.create!(user: user2, post: post)

      expect {
        Notification.create!(
          visitor: user2,           # 通知を送る側
          visited: user,            # 通知を受ける側
          action:  :like,           # enum: { like: 0 } を想定
          notifiable: like          # ポリモーフィック関連
        )
      }.to change(Notification, :count).by(1)
    end
  end
end
