class PostsController < ApplicationController
  before_action :set_post, only: %i[edit update show destroy]
  before_action :authenticate_user!, except: %i[index show]

  def index
    @posts = if user_signed_in?
               Post.where(user: current_user.following).order(created_at: :desc)
             else
               []
             end
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
    # Сохраняем предыдущую страницу перед удалением

    back_url = request.referer

    if @post.user == current_user
      @post.destroy
      flash[:success] = 'Пост успешно удален.'

      # Проверяем, является ли предыдущая страница страницей удаленного поста
      if back_url == post_url(@post)
        redirect_to posts_path
      else
        redirect_to back_url
      end
    else
      flash[:alert] = 'Вы не можете удалить этот пост.'
      redirect_to posts_path
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
