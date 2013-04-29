module CalendarHelper
  
  def month_link(month_date)
    link_to(I18n.localize(month_date, :format => "%B"), {:month => month_date.month, :year => month_date.year})
  end

  # custom options for this calendar
  def event_calendar_options
    { 
      :year => @year,
      :month => @month,
      :event_strips => @event_strips,
      :month_name_text => I18n.localize(@shown_month, :format => "%B %Y"),
      :previous_month_text => "<< " + month_link(@shown_month.prev_month),
      :next_month_text => month_link(@shown_month.next_month) + " >>"
    }
  end

  def event_calendar
    calendar event_calendar_options do |args|
      event = args[:event]
      
      event_start_time = "#{h(event.start_at.strftime("%H:%M"))}"
      event_end_time = "#{h(event.end_at.strftime("%H:%M"))}"

      event_start_date = "#{h(event.start_date)}"
      event_end_date = "#{h(event.end_date)}"

      event_text = "#{h(event.name)} | \n#{event_start_time}-#{event_end_time}"
      event_hover_text = 
      "#{h(event.name)}\n From: #{event_start_time}\n To: #{event_end_time}"

      if event.task != nil
        client_name = event.task.phase.project.client.name
        event_hover_text << "\nWith: #{client_name}"
      end

      %(<a href="/events/#{event.id}" title="#{h(event_hover_text)}">#{h(event_text)}</a>)
    end
  end
end