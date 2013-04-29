class StaticPagesController < ApplicationController
  def home
    if logged_in?
      flash.keep
      redirect_to user_path(current_user)
    end
  end

  def contact
  end

  def user_guide
  end

  def plans
  end
  
end
