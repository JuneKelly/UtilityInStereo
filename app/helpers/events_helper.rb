module EventsHelper

  def set_start_at(event, date, time)
    event.start_at = "#{date} #{time}"
  end

  def set_end_at(event, date, time)
    event.end_at = "#{date} #{time}"
  end

  def set_start_date(event, start_date)
    
  end

  def set_end_date(event, end_date)

  end

  def set_start_time(event, start_time)
    
  end

  def set_end_time(event, end_time)
    
  end

end
