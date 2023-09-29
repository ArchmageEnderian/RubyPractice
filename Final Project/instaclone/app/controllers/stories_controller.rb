class StoriesController < ApplicationController
  before_action :set_story, only: %i[show destroy]
  before_action :authenticate_user!, except: %i[index show]

  def index
    @stories = if user_signed_in?
                 Story.where(user: current_user.following).order(created_at: :desc)
               else
                 []
               end
  end


  def new
    @story = current_user.stories.build
  end

  def create
    @story = current_user.stories.build(story_params)
    if @story.save
      redirect_to stories_path, notice: 'Story was successfully created.'
    else
      render :new
    end
  end

  def show
    # @story -> before_action :set_story
  end

  def destroy
    @story.destroy
    redirect_to stories_path, notice: 'Story was successfully destroyed.'
  end

  private

  def set_story
    @story = Story.find(params[:id])
  end

  def story_params
    params.require(:story).permit(:description, :image)
  end
end
