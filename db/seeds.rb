areas = [
  { name: "北海道" },
  { name: "青森県" },
  { name: "岩手県" },
  { name: "宮城県" },
  { name: "秋田県" },
  { name: "山形県" },
  { name: "福島県" },
  { name: "茨城県" },
  { name: "栃木県" },
  { name: "群馬県" },
  { name: "埼玉県" },
  { name: "千葉県" },
  { name: "東京都" },
  { name: "神奈川県" },
  { name: "新潟県" },
  { name: "富山県" },
  { name: "石川県" },
  { name: "福井県" },
  { name: "山梨県" },
  { name: "長野県" },
  { name: "岐阜県" },
  { name: "静岡県" },
  { name: "愛知県" },
  { name: "三重県" },
  { name: "滋賀県" },
  { name: "京都府" },
  { name: "大阪府" },
  { name: "兵庫県" },
  { name: "奈良県" },
  { name: "和歌山県" },
  { name: "鳥取県" },
  { name: "島根県" },
  { name: "岡山県" },
  { name: "広島県" },
  { name: "山口県" },
  { name: "徳島県" },
  { name: "香川県" },
  { name: "愛媛県" },
  { name: "高知県" },
  { name: "福岡県" },
  { name: "佐賀県" },
  { name: "長崎県" },
  { name: "熊本県" },
  { name: "大分県" },
  { name: "宮崎県" },
  { name: "鹿児島県" },
  { name: "沖縄県" }
]

areas.each do |area|
  Area.find_or_create_by(name: area[:name])
end

categories = [
  { name: "zoo" },
  { name: "aqua" }
]

categories.each do |category|
  Category.find_or_create_by(name: category[:name])
end


# 初期ユーザー
user = User.find_or_create_by!(email: ENV["MASTER_EMAIL"]) do |u|
  u.password = ENV["MASTER_PASSWORD"]
  u.password_confirmation = ENV["MASTER_PASSWORD"]
  u.name = "AquaZooBridge"
end

posts = [
  {
    word: "ゆったりと竹をかじる姿に癒やされて、時間が止まったように感じました。",
    body: "上野動物園でパンダを見たとき、いつも行列ができていて「やっと会えた！」という気持ちになったのを覚えています。実際に目の前で笹を食べる姿は、写真や映像で見るよりずっと愛らしくて、観覧の短い時間の中でも十分に心に残りました。帰り道にはパンダグッズをいくつか買ってしまって、動物園を出たあともしばらく余韻に浸っていたのが良い思い出です。",
    area_id: Area.find_by!(name: "東京都").id,
    category_id: Category.find_by!(name: "zoo").id,
    user_id: user.id,
    image: "ueno.jpg",
    facility_attributes: {
      name: "上野動物園",
      official_url: "https://www.tokyo-zoo.net/zoo/ueno/"
    }
  },
  {
    word: "夜のライトに浮かび上がる姿は、まるで北極の大地を思わせる迫力がありました。",
    body: "旭山動物園に行ったとき、ホッキョクグマの展示が特に印象に残っています。透明なドームから見上げると、すぐそばを歩く大きなシロクマの足音や体の重みまで伝わってきて、子ども心に戻ってワクワクしました。水に飛び込む瞬間を見られたときは観客みんなが歓声をあげていて、その一体感も忘れられない思い出です。",
    area_id: Area.find_by!(name: "北海道").id,
    category_id: Category.find_by!(name: "zoo").id,
    user_id: user.id,
    image: "asahiyama.jpg",
    facility_attributes: {
      name: "旭山動物園",
      official_url: "https://www.city.asahikawa.hokkaido.jp/asahiyamazoo/"
    }
  }

]

posts.each do |post|
  post_record = Post.find_or_create_by!(
  word: post[:word],
  user_id: post[:user_id]
) do |p|
  p.body        = post[:body]
  p.area_id     = post[:area_id]
  p.category_id = post[:category_id]
  p.facility_attributes = {
    name: post.dig(:facility_attributes, :name),
    official_url: post.dig(:facility_attributes, :official_url)
  }
end

  image_path = Rails.root.join("db", "seeds", "images", "posts", post[:image])

  if File.exist?(image_path)
    post_record.image.attach(io: File.open(image_path), filename: post[:image])
  else
    puts "画像ファイルが見つかりません: #{image_path}"
  end
end
