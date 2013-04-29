class Event < ActiveRecord::Base
  attr_accessible :start_at, :end_at, :details, :task_id, 
                  :all_day, :title, :is_public

  attr_accessor :start_date, :end_date, :start_time, :end_time

  before_save :ensure_correct_user, :check_times
  # Todo: check dates and times are in sequence

  has_event_calendar name_field: :title

  belongs_to :user
  belongs_to :task

  validates_presence_of :title, :start_at, :end_at
  validates :user_id, presence: true

  # Scopes
  scope :public_events, where(is_public: true)

  def name
    return self.title
  end

  def start_date
    if self.start_at.nil?
      return nil
    else
      return self.start_at.strftime("%m/%d/%Y")
    end
  end

  def end_date
    if self.end_at.nil?
      return nil
    else
      return self.end_at.strftime("%m/%d/%Y")
    end
  end

  # def start_time
    
  # end

  # def end_time
    
  # end

  def ensure_correct_user
    if !task_id.nil?
      task_user = Task.find_by_id(task_id).user
      if task_user == user
        return true
      else
        return false
      end
    else
      return true
    end
  end

  def check_times
    if !self.end_at.nil?
      s = self.start_at.to_time
      e = self.end_at.to_time
      if e <= s
        return false
      else
        return true
      end
    end
  end
end
