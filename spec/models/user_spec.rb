require 'rails_helper'

RSpec.describe User, type: :model do
  describe "バリデーション成功" do
    it "有効なユーザーは保存できる" do
      user = User.new(
        name: "テストユーザー",
        email: "test@example.com",
        password: "password"
      )
      expect(user).to be_valid
    end
  end

  describe "バリデーション失敗" do
    it "nameが空白の時はユーザー登録できない" do
      user = User.new(
        name: "",
        email: "test@example.com",
        password: "password"
      )
    expect(user).not_to be_valid
    end

    it "nameが50文字以上の時はユーザー登録できない" do
      user = User.new(
        name: "a" * 51,
        email: "test@example.com",
        password: "password"
      )
    expect(user).not_to be_valid
    end

    it "emailが空白の時はユーザー登録できない" do
      user = User.new(
        name: "テストユーザー",
        email: "",
        password: "password"
      )
    expect(user).not_to be_valid
    end

    it "emailが重複している時はユーザー登録できない" do
      User.create(
        name: "テストユーザー",
        email: "test@example.com",
        password: "password"
      )

      dup = User.new(
    name: "別のユーザー",
    email: "test@example.com",
    password: "password"
      )
    expect(dup).not_to be_valid
    end

    it "passwordが5文字以下の時はユーザー登録できない" do
      user = User.new(
        name: "テストユーザー",
        email: "test@example.com",
        password: "p" * 5
      )
    expect(user).not_to be_valid
    end

    it "providerとuidが重複した時はユーザー登録できない" do
      User.create!(
        name: "テストユーザー",
        email: "test@example.com",
        password: "password",
        provider: "google",
        uid: "12345"
      )

      dup_user = User.new(
        name: "別のユーザー",
        email: "other@example.com",
        password: "password",
        provider: "google",
        uid: "12345"
      )
      expect(dup_user).not_to be_valid
    end
  end

  describe "関連削除" do
    it "ユーザーが削除されたらpostも削除される" do
      user = User.create!(name: "太郎", email: "aro@example.com", password: "password")
      category = Category.create!(name: "aqua")
      area = Area.create!(name: "北海道")
      facility = Facility.create!(name: "テスト動物園", official_url: "http://example.com")
      post = Post.create!(user: user, category: category, area: area, facility: facility, word: "ワード", body: "本文")

      expect {
      user.destroy!
    }.to change(Post, :count).by(-1)
    end
  end
end
