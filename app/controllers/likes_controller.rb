class LikesController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]

  def create
    @post = Post.find(params[:post_id])
    current_user.likes.find_or_create_by!(post: @post)

    respond_to do |format|
      format.turbo_stream  # ← likes/create.turbo_stream.erb を探す
      format.html { redirect_back fallback_location: post_path(@post) }
    end
  end

  def destroy
  end
end
