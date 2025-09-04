class Post < ApplicationRecord
  # == ActiveStorage ==
  has_one_attached :image

  validates :word, presence: true, length: { maximum: 50 }
  validates :body, presence: true, length: { maximum: 500 }

  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user

  belongs_to :user
  belongs_to :category
  belongs_to :area
  belongs_to :facility

  accepts_nested_attributes_for :facility

  validate :image_content_type
  validate :image_size

  before_validation :normalize_facility

  private

  def normalize_facility
    if facility && facility.name.present?
      self.facility = Facility.find_or_create_by(name: facility.name) do |f|
        f.official_url = facility.official_url
      end
    end
  end

  # 特定の画像だけを保存
  def image_content_type
    return unless image.attached?
    allowed = %w[image/jpeg image/jpg image/png]
    unless image.content_type.in?(allowed)
      errors.add(:image, "は JPEG または PNG をアップロードしてください")
    end
  end

  def image_size
    return unless image.attached? && image.blob
    if image.blob.byte_size > 10.megabytes
      errors.add(:image, "は10MB以下にしてください")
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[ word body area_id ] # ← 検索対象にしてよいカラムだけを配列で返す
  end

  def self.ransackable_associations(auth_object = nil)
    %w[ area user category facility ]
  end
end
