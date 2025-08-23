class LikesController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]

  def create
    @like = current_user.likes.build(post_id: params[:post_id])
    if @like.save
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
  end
end
