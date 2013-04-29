include TimeHelper
include EventsHelper
include CalendarHelper

class EventsController < ApplicationController
  before_filter :logged_in_user, 
                only: [:show, :show_agenda, :show_week, :show_month,
                      :new, :create,:edit, :update, :destroy]
  before_filter :correct_user, only: [:show, :edit, :update, :destroy]

  # check account is active
  before_filter except: [] do |c| 
    c.check_is_active(current_user)
  end

  def show
    
  end

  def show_agenda
    @events = current_user.events.
                where("start_at >= ?", todays_date).
                  order("start_at ASC").
                    limit(8)

    if @events.count > 3
      @soon_events = @events[0..2]
      @later_events = @events[3..-1]
    else
      @soon_events = @events
      @later_events = []
    end
  end

  def show_week
    
  end

  def show_month
    @month = (params[:month] || Time.zone.now.month).to_i
    @year = (params[:year] || Time.zone.now.year).to_i

    @shown_month = Date.civil(@year, @month)

    @event_strips = current_user.events.event_strips_for_month(@shown_month)

  end

  def new
    @event = current_user.events.build
    @task = Task.find_by_id(params[:task_id])
    if @task && current_user == @task.phase.project.client.user
      @event.task_id = @task.id
    end
  end

  def create
    @event = current_user.events.build
    @event.title = params[:event][:title]
    @event.details = params[:event][:details]

    @task = Task.find_by_id(params[:event][:task_id])
    if @task && current_user = @task.phase.project.client.user
      @event.task_id = params[:event][:task_id]
    else
      @event.task_id = nil
    end

    set_start_at(@event, 
                us_date_to_db(params[:event][:start_date]),
                make_time(params[:start_time_h], params[:start_time_m]))

    set_end_at(@event,
              us_date_to_db(params[:event][:end_date]),
              make_time(params[:end_time_h], params[:end_time_m]))

    @event.is_public = params[:event][:is_public]


    if @event.save
      flash[:success] = "Event created: #{@event.title}"
      event_year = @event.start_at.strftime("%Y")
      event_month = @event.start_at.strftime("%m")
      if @event.task == nil
        clear_location
      end
      redirect_back_or(calendar_path(year: event_year,month: event_month))
    else
      flash.now[:error] = "Invalid data :( Check Event start and end times"
      render 'new'
    end
  end

  def edit
  end

  def update
    @event.title = params[:event][:title]
    @event.details = params[:event][:details]

    set_start_at(@event, 
                us_date_to_db(params[:event][:start_date]),
                make_time(params[:start_time_h], params[:start_time_m]))

    set_end_at(@event,
              us_date_to_db(params[:event][:end_date]),
              make_time(params[:end_time_h], params[:end_time_m]))

    # @event.start_date = us_date_to_db(params[:event][:start_date])
    # @event.end_date = us_date_to_db(params[:event][:end_date])
    # @event.start_time = make_time(params[:start_time_h],
    #                               params[:start_time_m])
    # @event.end_time = make_time(params[:end_time_h],
    #                               params[:end_time_m])

    @event.is_public = params[:event][:is_public]
    if @event.save
      flash[:success] = "Changes Saved: #{@event.title}"
      event_year = @event.start_at.strftime("%Y")
      event_month = @event.start_at.strftime("%m")
      redirect_to calendar_path(year: event_year, month: event_month)
    else
      render 'edit'
    end
  end

  def destroy
    @event.destroy
    flash[:success] = "Deleted event: #{@event.title}"
    event_year = @event.start_at.strftime("%Y")
    event_month = @event.start_at.strftime("%m")
    redirect_to calendar_path(year: event_year, month: event_month)
  end

  private 

    def correct_user
      @event = Event.find_by_id(params[:id])
      @user = @event.user
      if @user != current_user
        redirect_to(root_path, notice: "Error: wrong user")
      end
    end

end
