class Facility < ApplicationRecord
  has_many :posts

  validates :official_url, format: {
    with: URI::DEFAULT_PARSER.make_regexp(%w[http https]),
    message: "有効なURLを入力してください（http://またはhttps://で始まる必要があります）"
  }, presence: true

  validates :name, presence: true, length: { maximum: 50 }, uniqueness: true

  private

  def self.ransackable_attributes(auth_object = nil)
    %w[ name ] # ← 検索対象にしてよいカラムだけを配列で返す
  end
end
