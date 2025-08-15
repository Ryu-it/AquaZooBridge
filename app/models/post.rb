class Post < ApplicationRecord
  # == ActiveStorage ==
  has_one_attached :image

  has_many :likes

  belongs_to :user
  belongs_to :category
  belongs_to :area
  belongs_to :facility

  accepts_nested_attributes_for :facility

  validates :word, presence: true, length: { maximum: 50 }
  validates :body, presence: true, length: { maximum: 500 }
end
