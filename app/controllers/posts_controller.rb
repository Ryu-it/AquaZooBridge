class PostsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update destroy]
  before_action :set_post, only: %i[edit update destroy]
  before_action :authorize_owner!, only: %i[edit update destroy]

  def index
    @areas = Area.all
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true)
               .preload(:user)
               .order(created_at: :desc)
               .page(params[:page]).per(9)
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
      render "zoo_edit"
    when "aqua"
      render "aqua_edit"
    end
  end

  def update
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
    @post.destroy
    flash[:notice] = "削除に成功しました"
    redirect_to root_path
  end

  private

  # 自分の投稿だけを見つける
  def set_post
    @post = Post.find(params[:id])
  end

  # 投稿のidと今のユーザーのidを比較して遷移してメッセージ
  def authorize_owner!
    unless @post.user_id == current_user.id
      redirect_to root_path, alert: "権限がありません"
    end
  end

  def post_params
    params.require(:post).permit(
    :word,
    :body,
    :area_id,
    :image,
    facility_attributes: [ :name, :official_url ]
    )
  end
end
