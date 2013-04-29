module TimeHelper
  def todays_date
    Time.now.strftime("%Y-%m-%d")
  end

  def us_date_to_db(date)
    if date.include?('/')
      pieces = date.split('/')
      year = pieces[2]
      month = pieces[0]
      day = pieces[1]

      result = "#{year}-#{month}-#{day}"
      return result
    else
      return date
    end
  end

  def make_time(hours, minutes)
    result = "#{hours}:#{minutes}:00"
  end

  def hours_for_project(project)
    tasks = project.tasks
    project_events = []
    tasks.each do |t|
      project_events << t.events
    end
    project_events = project_events.flatten

    hours = project_events.inject(0) do |sum, e|
      sum + ((e.end_at.to_time - e.start_at.to_time) / 1.hour).round
    end
    return hours
  end

  def events_for_year_month(year, month)
    
  end
end