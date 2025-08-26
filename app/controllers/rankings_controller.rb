class RankingsController < ApplicationController
  def show
    post =
    @rankings = Facility.left_joins(posts: :likes)
                        .group("facilities.id")
                        .select("facilities.*, COUNT(likes.id) AS likes_count")
                        .order("likes_count DESC")
                        .limit(5)
  end
end
