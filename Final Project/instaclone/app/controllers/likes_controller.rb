class LikesController < ApplicationController
  before_action :find_post
  before_action :find_like, only: [:destroy]

  def create
    if already_liked?
      flash[:notice] = 'Как ни прискорбно, но больше 1 лайка поставить нельзя'
    else
      @post.likes.create(user_id: current_user.id)
    end

    redirect_to post_path(@post), notice: 'Осознавая красоту этого красного сердца,
                  царящего в центре своего пространства... Вы наполняетесь решимостью!'
  end

  def destroy
    if !(already_liked?)
      flash[:notice] = 'Нельзя разлайкать'
    else
      @like.destroy
    end
    redirect_to post_path(@post)
  end

  private

  def find_post
    @post = Post.find(params[:post_id])
  end

  def find_like
    @like = @post.likes.find_by(id: params[:id])
    unless @like
      flash[:alert] = 'Лайк не найден'
      redirect_to post_path(@post) and return
    end
  end


  def already_liked?
    Like.where(user_id: current_user.id, post_id: params[:post_id]).exists?
  end
end
