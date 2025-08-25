class LookupsController < ApplicationController
  def create
    name = params.require(:lookup).require(:name)

    # まずDBを探す
    facility = Facility.find_by(name: name)

    if facility.present?
      # 既にあるのでAPIは叩かずそのまま返す
      render json: { name: facility.name, url: facility.official_url }
    else
      # DBにない場合のみAPIを叩く
      url = Rails.cache.fetch([ "official_site", name ], expires_in: 1.day) do
        GoogleCustomSearch.new.official_site_url_for(name)
      end

      if url.present?
        facility = Facility.create!(name: name, official_url: url)
        render json: { name: facility.name, url: facility.official_url }
      else
        render json: { error: "見つかりませんでした" }, status: :not_found
      end
    end
  rescue => e
    Rails.logger.error(e.full_message)
    render json: { error: "検索に失敗しました" }, status: :bad_gateway
  end
end
