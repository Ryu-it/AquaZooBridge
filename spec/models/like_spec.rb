require 'rails_helper'

RSpec.describe Like, type: :model do
  describe "バリデーション成功" do
    it "投稿にいいねが成功する" do
    user = User.create!(name: "太郎", email: "aro@example.com", password: "password")
    category = Category.create!(name: "aqua")
    area = Area.create!(name: "北海道")
    facility = Facility.create!(name: "テスト動物園", official_url: "https://example.com")
    post = Post.create!(user: user, category: category, area: area, facility: facility, word: "ワード", body: "本文")

    like = Like.new(user: user, post: post)
    expect { like.save! }.to change(Like, :count).by(1)
    end
  end

  describe "バリデーション失敗" do
    it "同ユーザーが同じ投稿にいいねを複数回する時は失敗" do
    user = User.create!(name: "太郎", email: "aro@example.com", password: "password")
    category = Category.create!(name: "aqua")
    area = Area.create!(name: "北海道")
    facility = Facility.create!(name: "テスト動物園", official_url: "https://example.com")
    post = Post.create!(user: user, category: category, area: area, facility: facility, word: "ワード", body: "本文")

    like = Like.create!(user: user, post: post)
    dup = Like.new(user: user, post: post)

    expect { dup.save }.not_to change(Like, :count)
    expect(dup).not_to be_valid
    end
  end
end
