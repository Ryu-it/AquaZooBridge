class PostsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update destroy track_official_click]
  before_action :set_post, only: %i[show edit update destroy]
  before_action :authorize_owner!, only: %i[edit update destroy]
  before_action :check_params_category, only: %i[new edit update index show]

  def index
      @areas = Area.all
      @q = Post.ransack(params[:q])
      scope = @q.result(distinct: true)
                .joins(:category)
                .where(categories: { name: params[:category] })

      @posts = scope
                .select("posts.*").distinct
                .order("posts.created_at DESC, posts.id DESC")
                .page(params[:page]).per(9)
                .preload(:user)

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
      render "zoo_show"
    when "aqua"
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
        redirect_to post_path(@post, category: "zoo")
      else
        redirect_to post_path(@post, category: "aqua")
      end

    else
      flash.now[:alert] = "投稿に失敗しました"

      # カテゴリーに応じて render を変える
      if @post.category.name == "zoo"
        render :zoo_new, status: :unprocessable_entity
      else
        render :aqua_new, status: :unprocessable_entity
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
      else
        redirect_to posts_path(category: "aqua")
      end

    else
      flash.now[:alert] = "編集に失敗しました"

      # カテゴリーに応じて render を変える
      if @post.category.name == "zoo"
        render :zoo_edit, status: :unprocessable_entity
      else
        render :aqua_edit, status: :unprocessable_entity
      end
    end
  end

  def destroy
    @post.destroy
    flash[:notice] = "削除に成功しました"
    redirect_to root_path
  end

  def track_official_click
    @post = Post.find(params[:id])
    CreateNotification.url_visit(visitor: current_user, post: @post)
    head :no_content
  end

  private

  # 自分の投稿だけを見つける
  def set_post
    @post = Post.find(params[:id])
  end

  # 投稿のidと今のユーザーのidを比較して遷移してメッセージ
  def authorize_owner!
    unless @post.user_id == current_user.id
      redirect_to root_path, alert: "権限がありません" and return
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

  def check_params_category
    unless params[:category].in?(%w[zoo aqua])
      redirect_to root_path, alert: "不正なアクセスです" and return
    end
  end
end
