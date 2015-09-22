class DreamsController < ApplicationController
  before_filter :authenticate_dreamer, except: [:index]
  before_filter :find_dream, except: [:index, :create, :new]

  def index
    @dreams = Dream.order('created_at DESC').limit(20)
    @dream = Dream.new
    @popular_dreams = Dream.popular
    redirect_to welcome_path unless current_dreamer
  end

  def show
    @comment = Comment.new
  end

  def create
    @dream = current_dreamer.dreams.new(dream_params)
    if @dream.save
      if dream_params[:hashtag_string]
        @dream.hashtags << Hashtag.parse(dream_params[:hashtag_string])
      end
      render @dream
    else
      error(@dream.errors.full_messages)
    end
  end

  def update
    if @dream.update_attributes(dream_params)
      render nothing: true
    else
      error(@dream.errors.full_messages)
    end
  end

  def destroy
    if @dream.destroy
    redirect_to root_path
    else
      error(@dream.errors.full_messages)
    end
  end

  private

  def dream_params
    params.require(:dream).permit(:title, :story, :decision_clarity, 
                      :consciousness_clarity, :dream_state_clarity, 
                      :hashtag_string)
  end

  def find_dream
    @dream = Dream.find(params[:id])
  end

end
