class TasksController < ApplicationController
  before_filter :logged_in_user, 
                only: [:show, :new,:create, :edit, :update, 
                        :mark_as_done, :destroy]
  before_filter :correct_user, only: [:show, :edit, :update, 
                                        :mark_as_done, :destroy]

  # check account is active
  before_filter except: [] do |c| 
    c.check_is_active(current_user)
  end

  def show
    @all_events = @task.events
  end

  def new
    @phase = Phase.find_by_id(params[:phase_id])
    if @phase.user == current_user
      @task = @phase.tasks.build
    else
      redirect_to root_path, notice: 'Error: wrong user'
    end
  end

  def create
    @phase = Phase.find_by_id(params[:phase_id])
    if @phase.user == current_user
      @task = @phase.tasks.build(params[:task])
      respond_to do |format|
        if @task.save
          flash[:success] = "Created task: #{@task.title}"
          format.html { redirect_back_or(phase_path(@phase)) }
          format.js
        else
          format.html { render 'new' }
        end
        format.js
      end
    else
      redirect_to root_path, notice: 'Error: wrong user'
    end
  end

  def edit
  end

  def update
    if @task.update_attributes(params[:task])
      flash[:success] = "Updated task: #{@task.title}"
      redirect_to phase_path(@task.phase)
    else
      render 'edit'
    end
  end

  def mark_as_done
    if @task.is_done == false
      if @task.mark_as_done
        flash[:success] = "Task '#{@task.title}' is done!"
        redirect_to project_path(@task.phase.project)
      else
        flash[:error] = "Couldn't mark task '#{@task.title}' as done :("
        redirect_to project_path(@task.phase.project)
      end
    else
      flash[:error] = "Task '#{@task.title}' is already done"
      redirect_to project_path(@task.phase.project)
    end
  end

  def destroy
    @task.destroy
    flash[:success] = "Deleted task: '#{@task.title}'"
    #
    respond_to do |format|
      format.html { redirect_to phase_path(@task.phase) }
      format.json { head :ok }
      format.js   # Respond to JS call
    end
  end

  private
    def correct_user
      @task = Task.find_by_id(params[:id])
      @user = @task.phase.project.user
      if @user != current_user
        redirect_to(root_path, notice: "Error: wrong user")
      end
    end
end
