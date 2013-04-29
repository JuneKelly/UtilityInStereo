
class SessionsController < ApplicationController
  def new
    if current_user
      redirect_to user_path(current_user)
    end
  end

  def create
    @user = User.find_by_email(params[:email])

    if @user && @user.authenticate(params[:password])
      if current_user
        logout
      end
      login(@user)
      flash[:notice] = "Logged in #{@user.name}"
      redirect_back_or(user_path(@user)) 
    else
      flash.now.alert = "Error: Email or password invalid"
      render 'new'
    end
  end

  def destroy
    logout
    clear_location
    redirect_to root_path, notice: "Logged Out"
  end
end
