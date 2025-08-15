class ProfilesController < ApplicationController
  before_action :authenticate_user!, only: %i[show update]
  def show
    @posts = current_user.posts
  end

  def update
  end
end
