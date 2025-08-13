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

      if @post.category.name == "zoo"
        redirect_to posts_path(category: "zoo")
      elsif @post.category.name == "aqua"
        redirect_to posts_path(category: "aqua")
      else
        redirect_to root_path
      end

    else
      flash.now[:alert] = "投稿に失敗しました"

      # カテゴリーに応じて render を変える
      if @post.category&.name == "zoo"
        render :zoo_new, status: :unprocessable_entity
      elsif @post.category&.name == "aqua"
        render :aqua_new, status: :unprocessable_entity
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  def edit
    case params[:category]
    when "zoo"
      @post = Post.find(params[:id])
      render "zoo_edit"
    when "aqua"
      @post = Post.find(params[:id])
      render "aqua_edit"
    end
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      flash[:notice] = "編集に成功しました"

      if @post.category.name == "zoo"
        redirect_to posts_path(category: "zoo")
      elsif @post.category.name == "aqua"
        redirect_to posts_path(category: "aqua")
      else
        redirect_to root_path
      end

    else
      flash.now[:alert] = "編集に失敗しました"

      # カテゴリーに応じて render を変える
      if @post.category&.name == "zoo"
        render :zoo_edit, status: :unprocessable_entity
      elsif @post.category&.name == "aqua"
        render :aqua_edit, status: :unprocessable_entity
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:notice] = "削除に成功しました"
    redirect_to root_path
  end

  private

  def post_params
    params.require(:post).permit(
    :word,
    :body,
    :area_id,
    :image,
    facility_attributes: [ :name ]
    )
  end
end
