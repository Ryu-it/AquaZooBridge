require 'rails_helper'

RSpec.describe Post, type: :model do
  describe "バリデーション成功" do
    it "投稿に成功する" do
      user = User.create!(name: "太郎", email: "aro@example.com", password: "password")
      category = Category.create!(name: "aqua")
      area = Area.create!(name: "北海道")
      facility = Facility.create!(name: "テスト動物園", official_url: "https://example.com")
      post = Post.new(user: user, category: category, area: area, facility: facility, word: "ワード", body: "本文")
      expect(post).to be_valid
      expect { post.save! }.to change(Post, :count).by(1)
    end
  end

  describe "バリデーション失敗" do
    it "facility.nameが空白の時は失敗" do
      user = User.create!(name: "太郎", email: "aro@example.com", password: "password")
      category = Category.create!(name: "aqua")
      area = Area.create!(name: "北海道")
      facility = Facility.new(name: "")
      post = Post.new(user: user, category: category, area: area, facility: facility, word: "ワード", body: "本文")
      expect(post).not_to be_valid
    end

    it "facility.nameの文字数が51文字以上の時は失敗" do
      user = User.create!(name: "太郎", email: "aro@example.com", password: "password")
      category = Category.create!(name: "aqua")
      area = Area.create!(name: "北海道")
      facility = Facility.new(name: "a" * 51)
      post = Post.new(user: user, category: category, area: area, facility: facility, word: "ワード", body: "本文")
      expect(post).not_to be_valid
    end

    it "facility.urlがhttp:やhttps:以外の時は失敗" do
      user = User.create!(name: "太郎", email: "aro@example.com", password: "password")
      category = Category.create!(name: "aqua")
      area = Area.create!(name: "北海道")
      facility = Facility.new(name: "テスト動物園", official_url: "httpp")
      post = Post.new(user: user, category: category, area: area, facility: facility, word: "ワード", body: "本文")
      expect(post).not_to be_valid
    end

    it "Post.wordが空白の時は失敗" do
      user = User.create!(name: "太郎", email: "aro@example.com", password: "password")
      category = Category.create!(name: "aqua")
      area = Area.create!(name: "北海道")
      facility = Facility.new(name: "テスト動物園")
      post = Post.new(user: user, category: category, area: area, facility: facility, word: "", body: "本文")
      expect(post).not_to be_valid
    end

    it "Post.wordが51文字以上の時は失敗" do
      user = User.create!(name: "太郎", email: "aro@example.com", password: "password")
      category = Category.create!(name: "aqua")
      area = Area.create!(name: "北海道")
      facility = Facility.new(name: "テスト動物園")
      post = Post.new(user: user, category: category, area: area, facility: facility, word: "a" * 51, body: "本文")
      expect(post).not_to be_valid
    end

    it "Post.bodyが空白の時は失敗" do
      user = User.create!(name: "太郎", email: "aro@example.com", password: "password")
      category = Category.create!(name: "aqua")
      area = Area.create!(name: "北海道")
      facility = Facility.new(name: "テスト動物園")
      post = Post.new(user: user, category: category, area: area, facility: facility, word: "ワード", body: "")
      expect(post).not_to be_valid
    end

    it "Post.bodyが501文字以上の時は失敗" do
      user = User.create!(name: "太郎", email: "aro@example.com", password: "password")
      category = Category.create!(name: "aqua")
      area = Area.create!(name: "北海道")
      facility = Facility.new(name: "テスト動物園")
      post = Post.new(user: user, category: category, area: area, facility: facility, word: "ワード", body: "a" * 501)
      expect(post).not_to be_valid
    end

    it "Post.imageのcontent_typeがjpegやpng以外の時は失敗" do
      user = User.create!(name: "太郎", email: "aro@example.com", password: "password")
      category = Category.create!(name: "aqua")
      area = Area.create!(name: "北海道")
      facility = Facility.new(name: "テスト動物園")

      image = ActiveStorage::Blob.create_and_upload!(
    io: StringIO.new("dummy gif content"), # 中身は何でもOK
    filename: "test.gif",
    content_type: "image/gif"
  )

      post = Post.new(image: image, user: user, category: category, area: area, facility: facility, word: "ワード", body: "a" * 501)
      expect(post).not_to be_valid
    end

    it "Post.imageのbyte_sizeが10MB以上の時は失敗" do
      user = User.create!(name: "太郎", email: "aro@example.com", password: "password")
      category = Category.create!(name: "aqua")
      area = Area.create!(name: "北海道")
      facility = Facility.new(name: "テスト動物園")

      image = ActiveStorage::Blob.create_and_upload!(
    io: StringIO.new("a" * (11.megabytes)), # 中身は何でもOK
    filename: "test.png",
    content_type: "image/png"
  )

      post = Post.new(image: image, user: user, category: category, area: area, facility: facility, word: "ワード", body: "a" * 501)
      expect(post).not_to be_valid
    end
  end
end
