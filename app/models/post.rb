class Post < ApplicationRecord
  # == ActiveStorage ==
  has_one_attached :image

  has_many :likes

  belongs_to :user
  belongs_to :category
  belongs_to :area
  belongs_to :facility

  accepts_nested_attributes_for :facility
end
