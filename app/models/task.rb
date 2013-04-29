class Task < ActiveRecord::Base
  attr_accessible :is_done, :title

  belongs_to :phase
  has_one :project, through: :phase
  has_one :client, through: :project
  has_one :user, through: :client

  has_many :events

  validates_presence_of :title
  validates :phase_id, presence: true

  def mark_as_done
    self.is_done = true
    self.save
  end

  def project
    return self.phase.project
  end

end
