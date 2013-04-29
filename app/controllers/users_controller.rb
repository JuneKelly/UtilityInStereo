include TimeHelper
include AccountHelper

class UsersController < ApplicationController
  before_filter :logged_in_user, only: [:show, :edit, :update, 
                                        :destroy, :account_inactive]
  before_filter :correct_user, only: [:show, :edit, :update, :destroy]

  # check account is active
  before_filter :except => [:index, :show, :edit, :update, :account_inactive] do |c| 
    c.check_is_active(current_user)
  end

  def index
    if check_admin(current_user)
      @users = User.all
      @new_clients = Client.where("created_at > ?", 7.days.ago).count
      @new_contacts = Contact.where("created_at > ?", 7.days.ago).count
      @new_projects = Project.where("created_at > ?", 7.days.ago).count
      @new_phases = Phase.where("created_at > ?", 7.days.ago).count
      @new_tasks = Task.where("created_at > ?", 7.days.ago).count
      @new_events = Event.where("created_at > ?", 7.days.ago).count
      @new_enquiries = Enquiry.where("created_at > ?", 7.days.ago).count
    else
      redirect_to root_path, notice: "Nope"
    end
  end

  def new
    @user = User.new
  end

  def create
    # @user = User.new(params[:user])
    # if @user.save
    #   login @user
    #   flash[:success] = "Welcome to Utility In Stereo :)"
    #   redirect_to @user
    # else
    #   render 'new'
    # end
  end

  def show
    @events = current_user.events.
                where("start_at >= ?", todays_date).
                  order("start_at ASC").
                    limit(8)
    @projects = current_user.projects
    @active_projects_count = 0
    @projects.each do |p|
      if p.is_done == false
        @active_projects_count += 1
      end
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Changed your user details :)"
      login @user
      redirect_to user_path(@user)
    else
      render 'edit'
    end
  end

  def destroy
  end

  def account_inactive
    if !current_user.nil? && current_user.is_active == false
      @user = current_user
    else
      redirect_to root_path
    end
  end

  private
    def correct_user
      @user = User.find(params[:id])
      if !current_user?(@user)
        redirect_to(root_path, notice: "Error: wrong user")
      end
    end
end
