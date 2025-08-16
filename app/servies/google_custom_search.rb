class GoogleCustomSearch
  include HTTParty
  base_uri "https://www.googleapis.com/customsearch/v1"

  def initialize(api_key: ENV["GOOGLE_CSE_API_KEY"], cx: ENV["GOOGLE_CSE_CX"])
    @api_key = api_key
    @cx      = cx
  end

  # 検索リクエストを送受信して、URLを取得
  def official_site_url_for(name)
    res = self.class.get("", query: {
      key: @api_key, cx: @cx,
      q: "#{name} 公式サイト",
      gl: "JP", lr: "lang_ja", num: 1,
      fields: "items(link)"
    })
    res.parsed_response.dig("items", 0, "link")
  rescue
    nil
  end
end
