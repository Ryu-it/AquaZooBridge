class PostsController < ApplicationController
  def index
    @posts = Post.includes(:user)
    case params[:category]
    when "zoo"
      render "zoo_index"
    when "aqua"
      render "aqua_index"
    end
  end

  def show
    case params[:category]
    when "zoo"
      @post = Post.find(params[:id])
      render "zoo_show"
    when "aqua"
      @post = Post.find(params[:id])
      render "aqua_show"
    end
  end

  def new
    @post = Post.new
    @post.build_facility
    case params[:category]
    when "zoo"
      render "zoo_new"
    when "aqua"
      render "aqua_new"
    end
  end

  def create
    @post = current_user.posts.build(post_params)
    @post.category = Category.find_by(name: params[:category])

    if @post.save
      flash[:notice] = "投稿に成功しました"
      redirect_to root_path
    else
      flash.now[:alert] = "投稿に失敗しました"
      render :aqua_new, status: :unprocessable_entity
    end
  end

  private

  def post_params
    params.require(:post).permit(
    :word,
    :body,
    :area_id,
    facility_attributes: [ :name ]
    )
  end
end
