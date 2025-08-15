class LikesController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]

  def create
    @like = current_user.likes.build(post_id: params[:post_id])
    if @like.save
      redirect_to root_path
      puts "いいね保存成功！"
    else
      # 具体的なエラーメッセージを表示
      puts "保存失敗: #{@like.errors.full_messages}"
      puts "受け取ったパラメータ: #{params.inspect}"
    end
end

  def destroy
  end
end
