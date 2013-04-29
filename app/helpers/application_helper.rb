module ApplicationHelper
  def todays_date
    Time.now.strftime("%Y-%m-%d")
  end

end
