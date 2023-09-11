class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @post, notice: 'Ваш комментарий был успешно добавлен.'
    else
      redirect_to @post, alert: 'Ошибка при добавлении комментария. Пожалуйста, попробуйте снова.'
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @post = @comment.post

    if current_user == @comment.user || current_user == @post.user
      @comment.destroy
      redirect_to @post, notice: 'Комментарий успешно удален.'
    else
      redirect_to @post, alert: 'Вы не можете удалить этот комментарий.'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def set_post
    @post = Post.find(params[:post_id])
  end


end
