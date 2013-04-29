include TimeHelper
include ProgressHelper
include ProjectsHelper

class ProjectsController < ApplicationController
  before_filter :logged_in_user, only: 
    [:new, :index, :done_projects, :show, :create,:edit,
    :update, :mark_as_done, :destroy, :reorder_phases, :un_archive]

  before_filter :correct_user, only: 
    [:show, :edit, :update,
    :mark_as_done, :destroy, :reorder_phases, :un_archive]

  # check account is active
  before_filter :except => [:client_view] do |c| 
    c.check_is_active(current_user)
  end

   
  def index
    clients = current_user.clients
    @projects = []
    clients.each do |client|
      client.projects.where("is_done = ?", false)
        .order("created_at DESC").each do |project|
        @projects << project
      end
    end
  end

  def done_projects
    clients = current_user.clients
    @projects = []
    clients.each do |client|
      client.projects.where("is_done = ?", true)
        .order("created_at DESC").each do |project|
        @projects << project
      end
    end
  end

  def show
    @phases = @project.phases.order("order_index ASC")
    @percent_complete = project_percent_complete(@project)
    @hours = hours_for_project(@project)
    store_location
  end

  def client_view
    @project = Project.find_by_long_id(params[:id])

    if @project == nil
      redirect_to root_path, notice: "That thing doesn't exist"
    else 
      if @project.has_client_view
        @percent_complete = project_percent_complete(@project)
        @user = @project.client.user

        if @user.is_active == false
          redirect_to root_path, notice: "Project not found"
        end

        @month = (params[:month] || Time.zone.now.month).to_i
        @year = (params[:year] || Time.zone.now.year).to_i
        @shown_month = Date.civil(@year, @month)

        events = @user.events

        @project_events = []
        events.each do |event|
          if event.task
            if event.task.project == @project && event.is_public
              @project_events << event
            end
          end
        end

        @project_events.sort! do |x, y|
          x.start_at <=> y.start_at
        end
      else
        redirect_to root_path, notice: "Nope"
      end
    end
  end

  def new
    check_limit
    @client = Client.find_by_id(params[:client_id])
    if @client.user == current_user
      @project = @client.projects.build
    else
      redirect_to root_path, notice: 'wrong user'
    end
  end

  def create
    check_limit
    @client = Client.find_by_id(params[:client_id])
    @project = @client.projects.build(params[:project])
    @project.deadline = us_date_to_db(params[:project][:deadline])
    if @client.user = current_user 
      if @project.save
        add_phases(@project, params[:template_type])
        flash[:success] = "Created project #{@project.title}"
        redirect_to project_path(@project)
      else
        render 'new'
      end
    else
      redirect_to root_path, notice: 'Error: wrong user'
    end
  end

  def edit
    if @project.is_done == true
      redirect_to project_path(@project), notice: "Sorry, the Project is Done"
    end
  end

  def reorder_phases
    @phases = @project.phases.order("order_index ASC")
  end

  def update
    @project.title = params[:project][:title]
    @project.details = params[:project][:details]
    @project.quotation = params[:project][:quotation]
    @project.is_done = params[:project][:is_done]
    @project.hourly_rate = params[:project][:hourly_rate]
    @project.deposit = params[:project][:deposit]
    @project.deposit_paid = params[:project][:deposit_paid]
    @project.is_paid_in_full = params[:project][:is_paid_in_full]
    @project.deadline = us_date_to_db(params[:project][:deadline])
    @project.has_client_view = params[:project][:has_client_view]
    @project.client_view_message = params[:project][:client_view_message]
    if @project.save
      flash[:success] = "Changes saved."
      redirect_to project_path(@project)
    else
      render 'edit'
    end
  end

  def mark_as_done
    if @project.is_done == false
      if @project.mark_as_done

        @project.phases.each do |phase|
          phase.mark_as_done
          phase.tasks.each do |task|
            task.mark_as_done
          end
        end

        flash[:success] = "Project '#{@project.title}' is done"
        redirect_to project_path(@project)
      else
        flash[:error] = "Something went wrong :("
        redirect_to project_path(@project)
      end
    else
      flash[:notice] = "Project '#{@project.title}' is already done."
      redirect_to project_path(@project)
    end
  end

  def un_archive
    if @project.is_done == true
      @project.is_done = false
      if @project.save
        flash[:notice] = "project un-archived"
        redirect_to(project_path @project)
      else
        redirect_to project_path @project
      end
    else
      redirect_to project_path @project
    end
  end

  def destroy
    @project.destroy
    flash[:success] = "Project '#{@project.title}' deleted."
    redirect_to projects_path
  end

  private
    def correct_user
      @project = Project.find_by_id(params[:id])
      @user = @project.user
      if @user != current_user
        redirect_to(root_path, notice: "Error: wrong user")
      end
    end

    def check_limit
      if current_user.projects.where("is_done = ?", false).count >= current_user.project_limit
        redirect_to projects_path, 
          notice: "Sorry, you have reached the limit for Projects on this account, consider upgrading to a standard account"
      end
    end
end
