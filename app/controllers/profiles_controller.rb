class ProfilesController < ApplicationController
  def show
    @posts = current_user.posts
  end

  def update
  end
end
