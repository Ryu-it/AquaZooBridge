class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :likes

  # 自分が送った通知
  has_many :active_notifications, class_name: "Notification",
  foreign_key: "visitor_id",
  dependent: :destroy

  # 自分が受け取った通知
  has_many :passive_notifications, class_name: "Notification",
  foreign_key: "visited_id",
  dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [ :google_oauth2 ]

  validates :uid, presence: true, uniqueness: { scope: :provider }, if: -> { uid.present? }

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.name = auth.info.name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end

  def self.create_unique_string
    SecureRandom.uuid
  end
end
