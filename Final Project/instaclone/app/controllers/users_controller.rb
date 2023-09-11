class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :followers, :followings]
  before_action :correct_user, only: [:edit, :update]

  def show
    @posts = @user.posts
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
    @posts = @user.posts
    render :show
  end

  def searchPage
    if params[:search].present?
      @users = User.where("username LIKE ?", "%#{params[:search]}%")
    else
      @users = []
    end
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
