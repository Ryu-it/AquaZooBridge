class LookupsController < ApplicationController
    def create
      name = params.require(:name)

      url = Rails.cache.fetch([ "official_site", name ], expires_in: 1.day) do
        GoogleCustomSearch.new.official_site_url_for(name)
      end

      if url
        render json: { name:, url: }
      else
        render json: { error: "見つかりませんでした" }, status: :not_found
      end
    rescue => e
      Rails.logger.error(e.full_message)
      render json: { error: "検索に失敗しました" }, status: :bad_gateway
    end
end
