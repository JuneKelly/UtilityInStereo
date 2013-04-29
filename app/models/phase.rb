class Phase < ActiveRecord::Base
  attr_accessible :details, :due_date, :flat_rate, 
                  :is_done, :is_flat_rate, :title

  after_initialize :determine_order_index
  before_save :unique_order_index?
  after_destroy :reorder_phases

  belongs_to :project
  has_one :client, through: :project
  has_many :tasks, dependent: :destroy

  validates_presence_of :title
  validates :project_id, presence: true

  validates_presence_of :order_index

  default_scope order("order_index ASC")

  def user
    self.client.user
  end

  def mark_as_done
    self.is_done = true
    self.save
  end

  def move_down
    all_phases = self.project.phases.order("order_index ASC")
    if self.order_index != (all_phases.count - 1).to_i 

      next_phase = all_phases.select do |p|
        p.order_index == self.order_index + 1
      end
      next_phase = next_phase[0]

      next_index = next_phase.order_index
      this_index = self.order_index

      # self.order_index = next_index
      # next_phase.order_index = this_index

      self.update_column(:order_index, next_index)
      next_phase.update_column(:order_index, this_index)

      #
    # binding.pry
      #
    end
  end

  def move_up
    all_phases = self.project.phases.order("order_index ASC")
    if self.order_index != 0

      prev_phase = all_phases.select do |p|
        p.order_index == self.order_index - 1
      end
      prev_phase = prev_phase[0]

      prev_index = prev_phase.order_index
      this_index = self.order_index

      self.order_index = prev_index
      prev_phase.order_index = this_index

      self.update_column(:order_index, prev_index)
      prev_phase.update_column(:order_index, this_index)

      #
     # binding.pry
      #
    end
  end

  def reorder_phases
    all_phases = self.project.phases
    all_phases.each do |phase|
      if phase.order_index > self.order_index
        phase.order_index = phase.order_index - 1
        phase.save
      end
    end
  end

  def unique_order_index?
    other_phases = self.project.phases
    other_indexes = []
    
    other_phases.each do |ph|
      if ph.id != self.id
        other_indexes << ph.order_index
      end
    end

    if other_indexes.index(self.order_index) == nil
      return true
    else
      return false
    end
  end

  def determine_order_index
    if self.order_index == nil 
      self.order_index = self.project.phases.count
    end
  end
end
