class Facility < ApplicationRecord
  has_many :posts

  validates :official_url, format: {
    with: URI::DEFAULT_PARSER.make_regexp(%w[http https]),
    message: "有効なURLを入力してください（http://またはhttps://で始まる必要があります）"
  }, allow_blank: true

  validates :name, presence: true, length: { maximum: 50 }
end
