class LookupsController < ApplicationController
  def create
    name = params.require(:name)

    # まずDBを探す
    facility = Facility.find_by(name: name)

    if facility.present?
      # 既にあるのでAPIは叩かずそのまま返す
      render json: { name: facility.name, url: facility.official_url }
    else
      # DBにない場合のみAPIを叩く
      url = GoogleCustomSearch.new.official_site_url_for(name)

      if url.present?
        render json: { name: name, url: url }
      else
        render json: { error: "見つかりませんでした" }, status: :not_found
      end
    end
  rescue => e
    Rails.logger.error(e.full_message)
    render json: { error: "検索に失敗しました" }, status: :bad_gateway
  end
end
