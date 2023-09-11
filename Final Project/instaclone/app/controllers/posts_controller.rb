class PostsController < ApplicationController
  before_action :set_post, only: [:edit, :update, :show, :destroy]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @posts = Post.all # получаем все посты
  end

  def new
    @post = Post.new # создаем новый пустой объект post для формы
  end

  def create
    @post = current_user.posts.build(post_params) # создаем новый пост от текущего пользователя

    if @post.save
      redirect_to @post, notice: 'Post was successfully created.'
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
    @post.destroy
    redirect_to posts_path, notice: 'Post was successfully deleted.'
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:image, :description)
  end
end
