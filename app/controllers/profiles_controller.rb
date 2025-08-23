class ProfilesController < ApplicationController
  before_action :authenticate_user!, only: %i[show]
  def show
    @posts = current_user.posts
  end
end
