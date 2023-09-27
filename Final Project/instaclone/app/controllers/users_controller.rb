class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy followers followings follow unfollow]
  before_action :correct_user, only: %i[edit update]

  def show
    @posts = @user.posts.order(created_at: :desc)
  end

  def followers
    @followers = @user.followers
  end

  def followings
    @followings = @user.following
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update(user_params)
      redirect_to @user, notice: 'Профиль успешно обновлен.'
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace('error_explanation', partial: 'shared/form_errors', locals: { object: @user })
        end
        format.html { render :edit }
      end
    end
  end

  def profile
    @user = current_user
    @posts = @user.posts.order(created_at: :desc)
    render :show
  end

  def searchPage
    @users = if params[:search].present?
               User.where("username LIKE ?", "%#{params[:search]}%")
             else
               []
             end
  end

  def follow
    current_user.follow(@user)
    redirect_to @user, notice: 'Вы успешно подписались!'
  end

  def unfollow
    current_user.unfollow(@user)
    redirect_to @user, notice: 'Вы отписались.'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :email, :avatar, :bio, :phone_number, :gender, :private_account)
  end

  def correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path, alert: "Вы не можете редактировать профиль другого пользователя."
    end
  end

end
