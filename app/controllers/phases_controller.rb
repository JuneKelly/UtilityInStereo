include TimeHelper

class PhasesController < ApplicationController
  before_filter :logged_in_user, 
                only: [:new, :show, :create,:edit, :update,
                       :mark_as_done, :destroy, :move_up, :move_down]
  before_filter :correct_user, 
                only: [:show, :edit, :update, 
                      :mark_as_done, :destroy, :move_up, :move_down]

  # check account is active
  before_filter except: [] do |c| 
    c.check_is_active(current_user)
  end

  def show
    @tasks = @phase.tasks.order("created_at ASC")
    store_location
  end

  def new
    @project = Project.find_by_id(params[:project_id])
    if @project.user == current_user
      @phase = @project.phases.build
    else
      redirect_to root_path, notice: 'wrong user'
    end
  end

  
  def create
    @project = Project.find_by_id(params[:project_id])
    @phase = @project.phases.build(params[:phase])
    @phase.due_date = us_date_to_db(params[:phase][:due_date])
    if @project.user == current_user 
      if @phase.save
        flash[:success] = "Created phase #{@phase.title}"
        redirect_to phase_path(@phase)
      else
        render 'new'
      end
    else
      redirect_to root_path, notice: 'Error: wrong user'
    end
  end

  def edit
    if @phase.project.is_done == true
      redirect_to project_path(@phase.project), notice: "Sorry, the Project is Done"
    end
  end

  def move_down
    @phase.move_down
    redirect_to project_reorder_phases_path(@phase.project)
  end

  def move_up
    @phase.move_up
    redirect_to project_reorder_phases_path(@phase.project)
  end

  def mark_as_done
    if @phase.is_done == false
      if @phase.mark_as_done
        @phase.tasks.each do |task|
          task.mark_as_done
        end
        flash[:success] = "Phase '#{@phase.title}' is done"
        redirect_to project_path(@phase.project)
      else
        flash[:error] = "Something went wrong :("
        redirect_to project_path(@phase.project)
      end
    else
      flash[:notice] = "Phase is already done"
      redirect_to project_path(@phase.project)
    end
  end

  def update
    @phase.title = params[:phase][:title]
    @phase.details = params[:phase][:details]
    @phase.is_done = params[:phase][:is_done]
    @phase.is_flat_rate = params[:phase][:is_flat_rate]
    @phase.flat_rate = params[:phase][:flat_rate]
    @phase.due_date = us_date_to_db(params[:phase][:due_date])
    if @phase.save
      flash[:success] = "Changes Saved"
      redirect_to phase_path(@phase)
    else
      render 'edit'
    end
  end

  def destroy
    @phase.destroy
    flash[:success] = "Deleted Phase: #{@phase.title}"
    redirect_to project_path(@phase.project)
  end

  private
    def correct_user
      @phase = Phase.find_by_id(params[:id])
      @user = @phase.project.user
      if @user != current_user
        redirect_to(root_path, notice: "Error: wrong user")
      end
    end

    # def us_date_to_db(date)
    #   if date.include?('/')
    #     pieces = date.split('/')
    #     year = pieces[2]
    #     month = pieces[0]
    #     day = pieces[1]

    #     result = "#{year}-#{month}-#{day}"
    #     return result
    #   else
    #     return date
    #   end
    # end
end
