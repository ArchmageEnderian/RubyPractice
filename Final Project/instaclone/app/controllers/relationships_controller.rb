class RelationshipsController < ApplicationController
  def create
    @followed = User.find(params[:followed_id])

    if @followed
      current_user.follow(@followed)
      flash[:success] = "Вы подписались на #{@followed.username}!"
      redirect_to @followed
    else
      flash[:danger] = 'Ошибка при подписке.'
      redirect_to root_path
    end
  end

  def destroy
    @followed = Relationship.find(params[:id]).followed

    if @followed
      current_user.unfollow(@followed)
      flash[:success] = "Вы отписались от #{@followed.username}!"
      redirect_to @followed
    else
      flash[:danger] = 'Ошибка при отписке.'
      redirect_to root_path
    end
  end
end
