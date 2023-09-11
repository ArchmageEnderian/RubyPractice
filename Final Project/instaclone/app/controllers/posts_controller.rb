class PostsController < ApplicationController
  before_action :set_post, only: [:edit, :update, :show, :destroy]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @posts = Post.all # получаем все посты
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params) # создаем новый пост от текущего пользователя

    if @post.save
      redirect_to @post, notice: 'Пост успешно создан.'
    else
      render :new
    end
  end

  def edit
    # @post уже установлен благодаря before_action
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render :edit
    end
  end

  def show
    # @post уже установлен благодаря before_action
  end

  def destroy
    if @post.user == current_user
      @post.destroy
      flash[:notice] = "Пост успешно удален."
      redirect_to posts_path
    else
      flash[:alert] = "У вас нет прав для выполнения этого действия."
      redirect_to @post
    end
  end


  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:image, :description)
  end
end
